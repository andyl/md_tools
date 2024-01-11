defmodule Mix.Tasks.Test1 do

  use Mix.Task

  alias MdTools.Chunk.Doc

  def run(_) do
    MdTools.TestData.set1()
    |> Doc.ingest()
    |> IO.inspect()
  end
end
