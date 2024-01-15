defmodule MdTools.Application do
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
      children = [MdTools.Fts.Svc.Supervisor]
      opts = [strategy: :one_for_one, name: __MODULE__]

      Supervisor.start_link(children, opts)
  end
end
