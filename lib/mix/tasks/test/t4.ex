defmodule Mix.Tasks.Test.T4 do
  use Mix.Task

  def run(_) do
    "/home/aleak/util/org"
    |> MdTools.Docs.Dir.ingest()
    |> IO.inspect()
  end
end
