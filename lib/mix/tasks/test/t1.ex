defmodule Mix.Tasks.Test.T1 do

  use Mix.Task

  alias MdTools.Doc.Section

  def run(_) do
    MdTools.Data.Test.set1()
    |> Section.ingest()
    |> IO.inspect()
  end
end
