defmodule Mix.Tasks.Test1 do

  use Mix.Task

  alias MdTools.ProcText

  def run(_) do
    MdTools.TestData.set1()
    |> ProcText.ingest()
    |> IO.inspect()
  end
end
