defmodule Mix.Tasks.Compile.LvnEnv do
  use Mix.Task.Compiler
  alias Mix.Compilers.Erlang

  @impl true
  def run(args) do
    with {:ok, engines} <- Application.fetch_env(:phoenix_template, :compiled_template_engines) do
      Application.put_env(:phoenix_template, :compiled_template_engines, %{engines | heex: LiveViewNative.TagEngine})
    end

    :ok
  end
end