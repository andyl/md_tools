defmodule MdTools.Svc.Httpd.Server do

  @moduledoc false

  alias MdTools.Svc.Httpd.Router

  def child_spec(_) do
    IO.puts("Starting Httpd on https://localhost:5001")
    Supervisor.child_spec(
      {Bandit, scheme: :http, plug: Router, port: 5001},
      []
    )
  end
end

