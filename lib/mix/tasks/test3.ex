defmodule Mix.Tasks.Test3 do
  use Mix.Task

  def run(_) do
    base_path()
    |> MdTools.ProcDir.ingest()
    |> IO.inspect()
  end

  def base_path do
    root_dir =
      __ENV__.file
      |> String.split("/lib")
      |> hd()

    root_dir <> "/data"
  end
end
