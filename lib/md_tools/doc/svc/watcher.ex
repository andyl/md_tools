defmodule MdTools.Doc.Svc.Watcher do

  use GenServer

  alias MdTools.Util
  alias MdTools.Doc.Svc.DocStage


  @moduledoc """
  Watch the filesystem for changes.
  """

  @procname :doc_watcher

  # ----- startup

  @doc false
  def start_link(options \\ []) when is_list(options) do
    GenServer.start_link(__MODULE__, options, name: @procname)
  end

  @doc false
  def init(options) do
    args = [dirs: [options[:base_dir]]]
    Util.IO.puts("Starting DOC Watcher (#{inspect(args)})")
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  # ----- callbacks

  def handle_info({:file_event, _pid, {path, [:modified, :closed]}}, state) do
    if String.ends_with?(path, ".md") do
      IO.puts("Modified: #{path}")
      DocStage.upsert_file(path)
    end
    {:noreply, state}
  end

  def handle_info({:file_event, _pid, {path, [:deleted]}}, state) do
    if String.ends_with?(path, ".md") do
      IO.puts("Deleted: #{path}")
      DocStage.delete_file(path)
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
