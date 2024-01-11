defmodule MdTools.Db do

  alias Exqlite.Sqlite3

  def open(":memory:") do
    {:ok, conn} = Sqlite3.open(db)
    migrate(conn)
  end

  def open(dbfile) do
    dbexists = File.exists?(dbfile)
    {:ok, conn} = Sqlite3.open(db)
    unless dbexists, do: migrate(conn)
    conn
  end

  def migrate(conn) do
    cmd = "CREATE VIRTUAL TABLE IF NOT EXISTS sections USING fts5(filepath, doc_title, section_title, body, start_line);"
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, cmd)
    :done = Sqlite3.step(conn, statement)
    conn
  end

  def empty(conn) do
    cmd = "DELETE FROM sections;"
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, cmd)
    :done = Sqlite3.step(conn, statement)
    conn
  end

  def load(conn, list) do
    list |> Enum.each(&load_row(conn, &1))
    conn
  end

  def load_row(conn, data) do
    values = gen_values(data)
    cmd = "INSERT INTO sections (filepath, doc_title, section_title, body, start_line) VALUES (#{values}');"
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, cmd)
    :done = Sqlite3.step(conn, statement)
    conn
  end

  def gen_values(data) do
    "'#{data.path}', '#{data.doc_title}', '#{data.section_title}', '#{data.body}', '#{data.start_line}'"
  end

  def search(conn, query) do
    cmd = "SELECT * FROM sections WHERE sections MATCH '#{query}'"
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, cmd)
    :done = Sqlite3.step(conn, statement)
    conn
  end

end
