defmodule MdTools.Svc.Supervisor do

  @moduledoc false

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    if Application.get_env(:md_tools, :fts_server) do
      children = [
         MdTools.Svc.JobQueue
      ]

      Supervisor.init(children, strategy: :one_for_one)
    else
      :ignore
    end
  end

end
