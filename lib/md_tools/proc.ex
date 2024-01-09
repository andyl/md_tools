defmodule MdTools.Proc do

  def new_doc(args \\ %{}) do
    %{filename: "", line_count: 1, doc_title: "", sections: []}
    |> Map.merge(args)
  end

  def new_section do
    %{section_title: "", body: "", start_line: 0}
  end

  def to_list(data) do
    merge_data = %{
      filename: data.filename,
      doc_title: data.doc_title
    }
    data.sections
    |> Enum.map(&(Map.merge(&1, merge_data)))
  end

  def proc_line(line, data = %{sections: []}) do
    new_data =
      data
      |> add_section()
      |> set_start_line(data.line_count)

    proc_line(line, new_data)
  end

  def proc_line(line, data) do
    proc_line(line, data, has_section_title?(line))
  end

  def proc_line(line, data, true) do
    data
    |> increment_line_count()
    |> add_section()
    |> set_start_line(data.line_count)
    |> set_section_title(line)
    |> append_body(line)
  end

  def proc_line(line, data, false) do
    data
    |> increment_line_count()
    |> set_doc_title(line)
    |> append_body(line)
  end

  # -----

  defp has_doc_title?(line) do
    line |> String.starts_with?("# ")
  end

  defp has_section_title?(line) do
    line |> String.starts_with?("## ")
  end

  # -----

  defp set_doc_title(data = %{doc_title: ""}, line) do
    set_doc_title(data, line, has_doc_title?(line))
  end

  defp set_doc_title(data, _line) do
    data
  end

  defp set_doc_title(data, line, true) do
    title = line |> String.trim_leading("# ") |> String.trim()

    data
    |> Map.merge(%{doc_title: title})
  end

  defp set_doc_title(data, _line, _false) do
    data
  end

  # -----

  defp set_section_title(data, line) do
    set_section_title(data, line, has_section_title?(line))
  end

  defp set_section_title(data, line, true) do
    section = line |> String.trim_leading("## ") |> String.trim()

    data
    |> update_last_section(%{section_title: section})
  end

  defp set_section_title(data, _line, _false) do
    data
  end

  # -----

  defp increment_line_count(data) do
    current = data.line_count

    data
    |> Map.merge(%{line_count: current + 1})
  end

  # defp set_filename(data, filename) do
  # end

  defp add_section(data) do
    old_list = data.sections

    data
    |> Map.merge(%{sections: old_list ++ [new_section()]})
  end

  defp set_start_line(data, start_line) do
    data
    |> update_last_section(%{start_line: start_line})
  end

  defp append_body(data, line) do
    old_body = last_section(data).body

    data
    |> update_last_section(%{body: join_lines(old_body, line)})
  end

  # -----

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
end

