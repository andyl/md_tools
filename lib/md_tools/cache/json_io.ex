defmodule MdTools.Cache.JsonIO do
  alias MdTools.Doc.Section

  def read(file_path) do
    case File.exists?(file_path) do
      true ->
        file_path
        |> File.stream!()
        |> Enum.map(&parse_line_to_struct/1)

      false ->
        []
    end
  end

  def write(file, data) when is_list(data) do
    data
    |> Enum.map(&struct_to_json/1)
    |> Enum.join("\n")
    |> File.write(file)
  end

  def append(file, data) when is_list(data) do
    {file, data}
  end

  # -----

  defp parse_line_to_struct(line) do
    case Jason.decode(line) do
      {:ok, map} -> map_to_section(map)
      {:error, _reason} -> :error
    end
  end

  defp map_to_section(map) do
    %Section{
      body: map["body"],
      uuid: map["uuid"],
      updated: map["updated"],
      doctitle: map["doctitle"],
      sectitle: map["sectitle"],
      filepath: map["filepath"],
      filehash: map["filehash"],
      bodyhash: map["bodyhash"],
      startline: map["startline"],
    }
  end

  defp struct_to_json(struct) do
    struct
    |> Jason.encode!()
  end
end
