defmodule MdTools.SearchFts.Svc.FtsStage do
  use GenStage

  @procname :fts_stage

  def start_link(options \\ [parent: self()]) do
    GenStage.start_link(__MODULE__, options, name: @procname)
  end

  def init(state) do
    {:consumer, state}
  end

  def handle_events(events, _from, state) do
    send(state[:parent], {:events, events})
    {:noreply, [], state}
  end
end
