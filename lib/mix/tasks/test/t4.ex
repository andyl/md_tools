defmodule Mix.Tasks.Test.T4 do
  use Mix.Task

  def run(_) do
    "/home/aleak/util/org"
    |> MdTools.Doc.Dir.ingest()
    |> IO.inspect()
  end
end
