defmodule MdTools.Vss.Db do
  @moduledoc "Sqlite VSS operations."

  alias Exqlite.Sqlite3
  alias Exqlite.Basic
  alias MdTools.Vss.Embed

  def open(":memory:") do
    {:ok, conn} = Basic.open(":memory:")
    setup_vss_extensions(conn)
    migrate(conn.db)
  end

  def open(dbfile) do
    dbexists = File.exists?(dbfile)
    {:ok, conn} = Basic.open(dbfile)

    unless dbexists do
      setup_vss_extensions(conn)
      migrate(conn.db)
    end

    conn.db
  end

  def setup_vss_extensions(conn) do
    :ok = Basic.enable_load_extension(conn)
    # TODO: store these extensions in MdTools itself...
    Basic.load_extension(conn, "/home/aleak/.pkg/sqlite/vector0")
    Basic.load_extension(conn, "/home/aleak/.pkg/sqlite/vss0")
  end

  def migrate(conn) do
    [
      "CREATE TABLE IF NOT EXISTS docs (id INTEGER PRIMARY KEY AUTOINCREMENT, filepath TEXT, doctitle TEXT, sectitle TEXT, body TEXT, startline INTEGER);",
      "CREATE VIRTUAL TABLE IF NOT EXISTS vecs USING vss0(v_filepath(384), v_doctitle(384), v_sectitle(384), v_body(384));"
    ]
    |> Enum.each(fn cmd ->
      {:ok, statement} = Sqlite3.prepare(conn, cmd)
      :done = Sqlite3.step(conn, statement)
    end)

    conn
  end

  def empty(conn) do
    ["DELETE FROM docs;", "DELETE FROM vecs;"]
    |> Enum.each(fn cmd ->
      {:ok, statement} = Sqlite3.prepare(conn, cmd)
      :done = Sqlite3.step(conn, statement)
    end)

    conn
  end

  def load(conn, list) do
    list |> Enum.each(&load_row(conn, &1))
    conn
  end

  def load_row(conn, data) do

    values = gen_values(data)
    vectors = gen_vectors(values)

    [
      "INSERT INTO docs (filepath, doctitle, sectitle, body, startline) VALUES (#{values});",
      # "INSERT INTO vecs (v_filepath, v_doctitle, v_sectitle, v_body) VALUES (#{vectors});"
      "INSERT INTO vecs (v_filepath) VALUES (#{vectors});"
    ]
    |> Enum.each(fn cmd ->
      statement =
        case Sqlite3.prepare(conn, cmd) do
          {:ok, result} ->
            result

          {:error, msg} ->
            IO.puts("-----")
            IO.puts(cmd)
            IO.inspect(msg, label: "MSGGG")
            IO.inspect(values, label: "VALL")
            :error
        end

      case statement do
        :error ->
          IO.puts("SKIPPING")
        result ->
          :done = Sqlite3.step(conn, result)
      end
    end)

    conn
  end

  def gen_values(data) do
    cleanbody = data.body |> String.replace("'", "")

    [data.filepath, data.doc_title, data.section_title, cleanbody, data.start_line]
  end

  def gen_vectors(input) when is_list(input) do
    input
    |> List.delete_at(-1)
    |> Embed.json_batch()
  end

  def gen_vectors(val) do
    IO.inspect(val)
    raise("BAD VALUE")
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
