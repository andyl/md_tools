defmodule MdTools.Util.DbFts do

  alias MdTools.Doc.Section

  def create_data_table(map, table) do
    values =
      map
      |> mapkeys()
      |> Enum.map(fn key -> "#{key} #{type(key, map)}" end)
      |> Enum.join(", ")

    "CREATE TABLE IF NOT EXISTS #{table} (id INTEGER PRIMARY KEY, #{values})"
  end

  def create_fts_table(table) do
    values = "doctitle, sectitle, body, uuid UNINDEXED, content='#{table}', content_rowid='id'"
    "CREATE VIRTUAL TABLE IF NOT EXISTS #{table}_fts USING fts5(#{values})"
  end

  def create_insert_trigger(table) do
    """
    CREATE TRIGGER #{table}_ai AFTER INSERT ON #{table}
      BEGIN
        INSERT INTO #{table}_fts (doctitle, sectitle, body, uuid)
        VALUES (new.doctitle, new.sectitle, new.body, new.uuid);
      END;
    """
    |> String.replace("\n", "")
  end

  def create_update_trigger(table) do
    """
    CREATE TRIGGER #{table}_ad AFTER DELETE ON #{table}
      BEGIN
          INSERT INTO #{table}_fts (#{table}_fts, rowid)
          VALUES ('delete', old.id, old.#{table}name, old.short_description);
      END
    """
    |> String.replace("\n", "")
  end

  def create_delete_trigger(table) do
    """
    CREATE TRIGGER #{table}_au AFTER UPDATE ON #{table}
      BEGIN
          INSERT INTO #{table}_fts (#{table}_fts, rowid, #{table}name, short_description)
          VALUES ('delete', old.id, old.#{table}name, old.short_description);
          INSERT INTO #{table}_fts (rowid, #{table}name, short_description)
          VALUES (new.id, new.#{table}name, new.short_description);
      END
    """
  end

  def insert_data_row(table, %Section{} = data) do
    fields =
      data
      |> mapkeys()
      |> Enum.join(", ")

    values =
      data
      |> mapkeys()
      |> Enum.map(&(prep_field(&1, data)))
      |> Enum.join(", ")

      "INSERT INTO #{table} (#{fields}) VALUES (#{values});"
  end

  # -----

  defp mapkeys(map) do
      map
      |> Map.keys()
      |> Enum.filter(&(&1 != :__struct__))
  end

  defp prep_field(key, map) do
    case type(key, map) do
      "TEXT" -> Map.get(map, key) |> String.replace("'", "") |> wrap_text()
      "INTEGER" -> Map.get(map, key)
    end
  end

  def wrap_text(string) do
    "'#{string}'"
  end

  defp type(key, map) do
    cond do
      is_binary(Map.get(map, key)) -> "TEXT"
      is_number(Map.get(map, key)) -> "INTEGER"
    end
  end
end
