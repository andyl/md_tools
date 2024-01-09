defmodule Mix.Tasks.Test1 do

  use Mix.Task

  alias MdTools.Proc

  def run(_) do
    MdTools.TestData.set1()
    |> String.split("\n")
    |> Enum.reduce(Proc.new_doc(), &Proc.proc_line/2)
    |> Proc.to_list()
    |> IO.inspect()
  end
end
