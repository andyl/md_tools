defmodule MdTools.ProcDir do
  def ingest(dir) do
    dir
    |> list_all_files()
    |> Enum.map(&Task.async(fn -> process_file(&1) end))
    |> Enum.map(&Task.await(&1, 5000))
  end

  def process_file(file) do
    file
    |> File.read!()
    |> MdTools.ProcText.ingest(%{filepath: file})
  end

  def list_all_files(base_path) do
    Path.wildcard(Path.join(base_path, "**/*"))
    |> Enum.filter(&File.regular?(&1))
    |> Enum.filter(&String.ends_with?(&1, ".md"))
  end
end
