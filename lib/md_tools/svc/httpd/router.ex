defmodule MdTools.Svc.Httpd.Router do
  @moduledoc false

  use Plug.Router, init_mode: :runtime

  require Logger

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, ":ok")
  end

  get "/query" do
    send_resp(conn, 200, ":query")
  end

  match _ do
    Logger.error("File not found: #{conn.request_path}")

    send_resp(conn, 404, "NOT FOUND")
  end
end
