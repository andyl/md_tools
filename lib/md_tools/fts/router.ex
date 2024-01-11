defmodule MdTools.Fts.Router do
  @moduledoc false

  use Plug.Router

  require Logger

  plug(:match)
  plug(:dispatch)

  get "/" do
    IO.puts("BASE1")
    send_resp(conn, 200, ":ok")
  end

  get "/query" do
    IO.puts("BASE2")
    send_resp(conn, 200, ":query")
  end

  match _ do
    Logger.error("File not found: #{conn.request_path}")

    send_resp(conn, 404, "NOT FOUND")
  end
end
