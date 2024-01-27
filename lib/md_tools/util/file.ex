defmodule MdTools.Util.File do
  def markdown_files(path) do
    case File.stat(path) do
      {:ok, %File.Stat{type: :directory}} ->
        File.ls!(path)
        |> Enum.reduce([], fn entry, acc ->
          full_path = Path.join(path, entry)
          acc ++ markdown_files(full_path)
        end)
        |> Enum.filter(&String.ends_with?(&1, ".md"))

      {:ok, %File.Stat{type: :regular}} ->
        [path]
        |> Enum.filter(&String.ends_with?(&1, ".md"))

      _ ->
        []
    end
  end

  def markdown_events(path) do
    path
    |> markdown_files()
    |> Enum.map(&gen_event/1)
  end

  def gen_event(path, operation \\ :upsert) do
    {operation, path, mtime(path)}
  end

  def mtime(path) do
    case File.stat(path) do
      {:ok, %File.Stat{mtime: mtime}} -> mtime |> format_mtime()
      {:error, _reason} -> {:error, :file_not_found}
    end
  end

  defp format_mtime({{year, month, day}, {hour, minute, second}}) do
    NaiveDateTime.new!(year, month, day, hour, minute, second)
    |> Calendar.strftime("%y%m%d%H%M%S")
  end

end

