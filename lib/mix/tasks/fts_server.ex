defmodule Mix.Tasks.Fts.Server do
  @shortdoc "Starts the fts server"

  @moduledoc "Starts the fts server"
  use Mix.Task

  require Logger

  @impl Mix.Task
  def run(_args) do
    Application.put_env(:md_tools, :fts_server, true)

    Logger.debug("server started on http://localhost:5001")

    Mix.Task.run("app.start", ["--preload-modules"])

    Mix.Tasks.Run.run(["--no-halt"])
  end
end
