defmodule Mix.Tasks.Test.T2 do
  use Mix.Task

  def run(_) do
    base_path()
    |> list_all_files()
    |> IO.inspect()
  end

  def base_path do
    root_dir =
      __ENV__.file
      |> String.split("/lib")
      |> hd()

    (root_dir <> "/data")
  end

  def list_all_files(base_path) do
    Path.wildcard(Path.join(base_path, "**/*"))
    |> Enum.filter(&File.regular?(&1))
  end
end
