defmodule MdTools.Fts.Svc.Watcher do
  use GenServer

  @process_name :fts_watcher

  alias MdTools.Fts.Svc.Indexer

  # ----- API

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    IO.puts("Starting FTS Watcher (#{inspect(args)})")
    new_args = args ++ [name: @process_name]
    {:ok, watcher_pid} = FileSystem.start_link(new_args)
    FileSystem.subscribe(@process_name)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  # ----- Callbacks

  def handle_info({:file_event, _pid, {path, [:modified, :closed]}}, state) do
    if String.ends_with?(path, ".md") do
      IO.puts("Modified: #{path}")
      Indexer.rebuild()
    end
    {:noreply, state}
  end

  def handle_info({:file_event, _pid, {path, [:deleted]}}, state) do
    if String.ends_with?(path, ".md") do
      IO.puts("Deleted: #{path}")
      Indexer.rebuild()
    end
    {:noreply, state}
  end

  def handle_info({:file_event, _pid, :stop}, state) do
    {:noreply, state}
  end

  def handle_info({:file_event, _pid, _signature}, state) do
    {:noreply, state}
  end

end
