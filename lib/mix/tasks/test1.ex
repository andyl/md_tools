defmodule Mix.Tasks.Test1 do

  use Mix.Task

  alias MdTools.Parse.Doc

  def run(_) do
    MdTools.Test.Data.set1()
    |> Doc.ingest()
    |> IO.inspect()
  end
end
