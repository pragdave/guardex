defmodule Mix.Tasks.Guard.Runner do

  use     GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(%{guardfile: guardfile}) do 
    {:ok, %{port: create_notifier(guardfile) } }
  end


  def handle_info({port, {:data, {flag, line}}},  state = %{port: port})
  when flag in [:eol, :noeol]  
  do
    IO.puts "Got: #{to_string(line)}"
    { :noreply, state }
  end

  def handle_info({port, {:exit_status, status}}, state = %{port: port}) do
    {:stop, {:watcher_exit, status}, state}
  end

  def terminate(reason, %{port: port}) do
    IO.puts "TERMINATING"
    :ok
  end
  # create a notifier process. Currently assumes guard is installed
  defp create_notifier(guardfile) do
    cwd = System.cwd
    ruby = "ruby" |> to_char_list |> :os.find_executable
    guardfile = Path.join([cwd, "guardfiles", guardfile])
    args = ["-S", "guard", "start", "-G", guardfile]
    :erlang.open_port({:spawn_executable, ruby},
                      [:stream,
                       :use_stdio,
                       :exit_status,
                       {:line, 16384},
                       {:args, args},
                       {:cd, to_char_list(cwd)}])
  end

end
