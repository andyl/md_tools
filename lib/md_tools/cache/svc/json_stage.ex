defmodule MdTools.Cache.Svc.JsonStage do

  use GenStage

  @moduledoc """
  JsonStage for ingesting documents - a GenStage consumer/producer.
  """

  @base_dir "/home/aleak/util/org"
  @procname :json_stage

  import MdTools.Util.Xmap

  # ----- api

  # def doc_base, do: @doc_base

  # ----- startup

  @doc """
  Start the JsonStage server
  """
  def start_link(options \\ []) do
    defaults = [base_dir: @base_dir]
    opts1 = Keyword.merge(defaults, options) |> Enum.into(%{})
    cname = opts1.base_dir |> Path.basename()
    opts2 = assign(opts1, :cname, cname)
    GenStage.start_link(__MODULE__, opts2, name: @procname)
  end

  @doc false
  @impl true
  def init(state) do
    {:producer_consumer, state}
  end

  # ----- callbacks

  @impl true
  def handle_events(events, _from, state) do
    IO.inspect(events, label: "EVENTS")
    IO.inspect(state, label: "STATE")
    {:noreply, events, state}
  end

  # ----- helpers

end
