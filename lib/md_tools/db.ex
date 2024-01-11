defmodule MdTools.Db do

  alias Exqlite.Sqlite3

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
    cmd = "CREATE VIRTUAL TABLE IF NOT EXISTS sections USING fts5(filepath, doc_title, section_title, body, start_line);"
    {:ok, statement} = Sqlite3.prepare(conn, cmd)
    :done = Sqlite3.step(conn, statement)
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

  def load_row(conn, data) do
    values = gen_values(data)
    cmd = "INSERT INTO sections (filepath, doc_title, section_title, body, start_line) VALUES (#{values});"
    statement = case Sqlite3.prepare(conn, cmd) do
      {:ok, result} -> result
      {:error, msg} ->
        IO.inspect msg
        IO.inspect values
        :error
    end
    :done = Sqlite3.step(conn, statement)
    conn
  end

  def gen_values(data) do
    cleanbody = data.body |> String.replace("'", "")
    ~s{'#{data.filepath}', '#{data.doc_title}', '#{data.section_title}', '#{cleanbody}', '#{data.start_line}'}
  end

  def search(conn, query) do
    cmd = "SELECT * FROM sections WHERE sections MATCH '#{query}' ORDER BY rank;"
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
