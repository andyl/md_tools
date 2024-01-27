defmodule MdTools.Doc.File do

  @moduledoc "Chunk a markdown file."

  @doc """
  Ingest a markdown document.

  Documents are chunked on sections denoted by the H2 `##` delimeter.
  """
  def ingest(filepath, args \\ %{}) do
    filepath
    |> File.read!()
    |> MdTools.Doc.Text.ingest(Map.merge(args, %{filepath: filepath}))
  end
end

