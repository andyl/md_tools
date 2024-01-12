defmodule MdTools.Split.Dir do
  @moduledoc "Parse a directory of markdown files."

  @doc """
  Parse a directory of markdown files.

  Each file contains a document.

  Documents are chunked on sections denoted by the H2 `##` delimeter.
  """
  def ingest(dir) do
    dir
    |> list_all_files()
    |> Enum.map(&Task.async(fn -> process_file(&1) end))
    |> Enum.map(&Task.await(&1, 5000))
  end

  defp process_file(file) do
    file
    |> File.read!()
    |> MdTools.Split.Doc.ingest(%{filepath: file})
  end

  defp list_all_files(base_path) do
    Path.wildcard(Path.join(base_path, "**/*"))
    |> Enum.filter(&File.regular?(&1))
    |> Enum.filter(&String.ends_with?(&1, ".md"))
  end
end
