defmodule MdTools.Fts.Svc.Httpd.Server do

  @moduledoc false

  alias MdTools.Fts.Svc.Httpd.Router

  def child_spec(_) do
    IO.puts("Starting FTS Httpd on https://localhost:5001")
    Supervisor.child_spec(
      {Bandit, scheme: :http, plug: Router, port: 5001},
      []
    )
  end
end

