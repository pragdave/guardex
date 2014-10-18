defmodule Mix.Tasks.Guard do

  use Mix.Task

  @shortdoc "Run Guard on an Elixir project"

  @moduledoc """

  Invoke using

  ```
  mix guard  [ guard-to-run ]
  ```

  The default _guard-to-run_, called `elixir_notifying_emacs`,
  monitors `lib/` and `tests/`, running `mix test` when a change is
  detected. We also notify Emacs with a success or failure
  notification, so we get a nice green-colored mode line when tests
  pass.

  Feel free to submit PRs with support for different notifications,
  watched directories, and so on.

  To add these, simply create a new Guardfile in `guardfiles/`.
  """
  def run(args) when is_list(args) do
    args
    |> parse
    |> Mix.Tasks.Guard.Runner.start_link
    |> wait_forever
  end

  defp parse([]),          do: %{ guardfile: "elixir_notifying_emacs" }
  
  defp parse([guardfile]), do: %{ guardfile: guardfile }
  
  defp parse(_) do
    Mix.shell.fatal("Usage:  mix guard [ guard-to-run ]")
    exit {:shutdown, 1}
  end
  
  defp wait_forever(arg) do
    receive do
      :ninety_nine_bottles_of_elixir_on_the_wall ->
        wait_forever(arg)
    end
  end

end
