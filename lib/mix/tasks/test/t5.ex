defmodule Mix.Tasks.Test.T5 do
  use Mix.Task

  def run(_) do
    "/home/aleak/util/org"
    |> MdTools.Split.Dir.ingest()
    |> List.flatten()
    |> length()
    |> IO.inspect()
  end
end
