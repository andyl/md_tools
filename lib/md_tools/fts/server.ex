defmodule MdTools.Fts.Server do

  @moduledoc false

  def child_spec(_) do
    Supervisor.child_spec(
      {Bandit, scheme: :http, plug: MdTools.Fts.Router, port: 5001},
      []
    )
  end
end

