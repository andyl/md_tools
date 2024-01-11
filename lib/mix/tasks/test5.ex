defmodule Mix.Tasks.Test5 do
  use Mix.Task

  def run(_) do
    "/home/aleak/util/org"
    |> MdTools.Chunk.Dir.ingest()
    |> List.flatten()
    |> length()
    |> IO.inspect()
  end
end
