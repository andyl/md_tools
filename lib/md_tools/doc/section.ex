defmodule MdTools.Doc.Section do

  @moduledoc """
  Chunk markdown text.
  """

  alias Uniq.UUID
  alias MdTools.Doc.Section

  defstruct doctitle: "",
            sectitle: "",
            filepath: "",
            startline: 0,
            body:     "",
            uuid:     "",
            updated:  "",
            filehash: "",
            bodyhash: ""

  @doc """
  Ingest a markdown document.

  Documents are chunked on sections denoted by the H2 `##` delimeter.
  """
  def ingest(text, iargs \\ %{}) do
    args = Map.merge(iargs, %{filehash: genhash(text)})

    text
    |> String.split("\n")
    |> Enum.reduce(new_doc(args), &proc_line/2)
    |> to_list()
    |> Enum.map(&sec_merge(&1))
  end

  defp sec_merge(map) do
    data = %{
      bodyhash: map.body |> genhash(),
      uuid: uuid(),
      updated: timestamp()
    }
    Map.merge(map, data)
  end

  defp new_doc(args) do
    %{filepath: "", linecount: 1, doctitle: "", sections: []}
    |> Map.merge(args)
  end

  defp new_section do
    %Section{sectitle: "", body: "", startline: 0}
  end

  defp to_list(data) do
    merge_data = %{
      filepath: data.filepath,
      filehash: data.filehash,
      doctitle: data.doctitle
    }
    data.sections
    |> Enum.map(&(Map.merge(&1, merge_data)))
  end

  defp proc_line(line, data = %{sections: []}) do
    new_data =
      data
      |> add_section()
      |> set_startline(data.linecount)

    proc_line(line, new_data)
  end

  defp proc_line(line, data) do
    proc_line(line, data, has_sectitle?(line))
  end

  # has section title
  defp proc_line(line, data, true) do
    data
    |> increment_linecount()
    |> add_section()
    |> set_startline(data.linecount)
    |> set_sectitle(line)
    |> append_body(line)
  end

  # does not have section title
  defp proc_line(line, data, false) do
    data
    |> increment_linecount()
    |> set_doctitle(line)
    |> append_body(line)
  end

  defp has_doctitle?(line) do
    line |> String.starts_with?("# ")
  end

  defp has_sectitle?(line) do
    line |> String.starts_with?("## ")
  end

  defp set_doctitle(data = %{doctitle: ""}, line) do
    set_doctitle(data, line, has_doctitle?(line))
  end

  defp set_doctitle(data, _line) do
    data
  end

  defp set_doctitle(data, line, true) do
    title = line |> String.trim_leading("# ") |> String.trim()

    data
    |> Map.merge(%{doctitle: title})
  end

  defp set_doctitle(data, _line, _false) do
    data
  end

  defp set_sectitle(data, line) do
    set_sectitle(data, line, has_sectitle?(line))
  end

  defp set_sectitle(data, line, true) do
    section = line |> String.trim_leading("## ") |> String.trim()

    data
    |> update_last_section(%{sectitle: section})
  end

  defp set_sectitle(data, _line, _false) do
    data
  end

  defp increment_linecount(data) do
    current = data.linecount

    data
    |> Map.merge(%{linecount: current + 1})
  end

  # defp set_filepath(data, filepath) do
  # end

  defp add_section(data) do
    old_list = data.sections

    data
    |> Map.merge(%{sections: old_list ++ [new_section()]})
  end

  defp set_startline(data, startline) do
    data
    |> update_last_section(%{startline: startline})
  end

  defp append_body(data, line) do
    old_body = last_section(data).body

    data
    |> update_last_section(%{body: join_lines(old_body, line)})
  end

  defp join_lines(line1, line2) do
    case line1 do
      "" -> line2
      _ -> [line1, line2] |> Enum.join("\n")
    end
  end

  defp split_sections(data) do
    Enum.split(data.sections, Enum.count(data.sections) - 1)
  end

  defp last_section(data) do
    {_first, [last]} = split_sections(data)
    last
  end

  defp update_last_section(data, newmap) do
    {first, [last]} = split_sections(data)
    newlast = Map.merge(last, newmap)
    Map.merge(data, %{sections: first ++ [newlast]})
  end

  defp genhash(text) do
    :crypto.hash(:md5, text)
    |> Base.encode16(case: :lower)
    |> String.slice(-6, 6)
  end

  defp uuid do
    UUID.uuid7(:slug)
  end

  defp timestamp do
    DateTime.utc_now() |> Calendar.strftime("%y%m%d%H%M%S")
  end
end

