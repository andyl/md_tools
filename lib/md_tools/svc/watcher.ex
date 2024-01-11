defmodule MdTools.Svc.Watcher do
  use GenServer

  @process_name :md_watcher

  alias MdTools.Svc.Indexer

  # ----- API

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    IO.puts("Starting Watcher (#{inspect(args)})")
    new_args = args ++ [name: @process_name]
    {:ok, watcher_pid} = FileSystem.start_link(new_args)
    FileSystem.subscribe(@process_name)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  # ----- Callbacks

  def handle_info({:file_event, _pid, {path, [:modified, :closed]}}, state) do
    if String.ends_with?(path, ".md"), do: Indexer.rebuild()
    {:noreply, state}
  end

  def handle_info({:file_event, _pid, {path, [:deleted]}}, state) do
    if String.ends_with?(path, ".md"), do: Indexer.rebuild()
    {:noreply, state}
  end

  def handle_info({:file_event, _pid, :stop}, state) do
    {:noreply, state}
  end

  def handle_info({:file_event, _pid, _signature}, state) do
    {:noreply, state}
  end

end
