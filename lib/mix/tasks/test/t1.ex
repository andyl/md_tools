defmodule Mix.Tasks.Test.T1 do

  use Mix.Task

  alias MdTools.Docs.Text

  def run(_) do
    MdTools.Data.Test.set1()
    |> Text.ingest()
    |> IO.inspect()
  end
end
