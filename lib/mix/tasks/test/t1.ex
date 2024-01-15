defmodule Mix.Tasks.Test.T1 do

  use Mix.Task

  alias MdTools.Split.Doc

  def run(_) do
    MdTools.Data.Test.set1()
    |> Doc.ingest()
    |> IO.inspect()
  end
end
