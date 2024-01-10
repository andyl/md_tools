defmodule Mix.Tasks.Test4 do
  use Mix.Task

  def run(_) do
    "/home/aleak/util/org"
    |> MdTools.ProcDir.ingest()
    |> IO.inspect()
  end
end
