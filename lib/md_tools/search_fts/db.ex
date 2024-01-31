defmodule MdTools.SearchFts.Db do

  @moduledoc "Sqlite full-text-search operations."

  alias Exqlite.Sqlite3
  alias MdTools.Util
  alias MdTools.Doc.Section

  def open do
    open(":memory:")
  end

  def open(":memory:") do
    {:ok, conn} = Sqlite3.open(":memory:")
    migrate(conn)
  end

  def open(dbfile) do
    dbexists = File.exists?(dbfile)
    {:ok, conn} = Sqlite3.open(dbfile)
    unless dbexists, do: migrate(conn)
    conn
  end

  def migrate(conn) do
    [
      Util.DbFts.create_data_table(%Section{}, "sections"),
      Util.DbFts.create_fts_table("sections"),
      Util.DbFts.create_insert_trigger("sections"),
      Util.DbFts.create_update_trigger("sections"),
      Util.DbFts.create_delete_trigger("sections"),
    ]
    |> Enum.each(fn cmd ->
      {:ok, statement} = Sqlite3.prepare(conn, cmd)
      :done = Sqlite3.step(conn, statement)
    end)
    conn
  end

  def empty(conn) do
    cmd = "DELETE FROM sections;"
    {:ok, statement} = Sqlite3.prepare(conn, cmd)
    :done = Sqlite3.step(conn, statement)
    conn
  end

  def load(conn, list) do
    list |> Enum.each(&load_row(conn, &1))
    conn
  end

  def load_row(conn, %Section{} = data) do
    cmd = MdTools.Util.DbFts.insert_data_row("sections", data)

    statement =
      case Sqlite3.prepare(conn, cmd) do
        {:ok, result} ->
          result

        {:error, msg} ->
          IO.inspect(msg)
          IO.inspect(cmd)
          :error
      end

    :done = Sqlite3.step(conn, statement)
    Sqlite3.release(conn, statement)
    conn
  end

  def select_all(conn) do
    cmd = "SELECT * FROM sections;"
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, cmd)
    gen_result(conn, statement, [], Sqlite3.step(conn, statement))
  end

  def search(conn, query) do
    cmd = """
    SELECT * FROM sections
    WHERE ROWID IN
    (SELECT ROWID FROM sections_fts WHERE sections_fts MATCH '#{query}' ORDER BY rank);
    """
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, cmd)
    gen_result(conn, statement, [], Sqlite3.step(conn, statement))
  end

  def gen_result(conn, statement, acc, {:row, val}) do
    gen_result(conn, statement, acc ++ [val], Sqlite3.step(conn, statement))
  end

  def gen_result(_conn, _statement, acc, :done) do
    acc
  end
end
