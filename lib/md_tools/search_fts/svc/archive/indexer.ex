defmodule MdTools.Fts.Svc.Indexer do
  @moduledoc """
  Throttles index rebuild requests.

  To use: `MdTools.Util.Indexer.rebuild()`

  If multiple calls are recieved within the delay time:

  - the first call will execute the rebuild
  - the second call will trigger another rebuild after the delay time
  - subsequent calls will be dropped

  The GenServer state is a tuple with two elements:
       1. the time of the last call
       2. the status, either `:open` or `:closed`
  """

  use GenServer

  # alias MdTools.Fts.Svc.Manager

  @delay 2000

  # ----- API

  def rebuild do
    GenServer.call(__MODULE__, :rebuild)
  end

  # ----- Startup

  @doc false
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc false
  def init(_) do
    IO.puts("Starting FTS Indexer")
    {:ok, {time_now(), :open}}
  end


  # ----- Callbacks

  def handle_call(:rebuild, _from, {last_call_time, :open}) do
    current_time = time_now()
    if current_time - last_call_time < @delay do
      Process.send_after(self(), :reopen, @delay + 1000)
      {:reply, :ok, {last_call_time, :closed}}
    else
      exec_rebuild()
      {:reply, :ok, {current_time, :open}}
    end
  end

  def handle_call(:rebuild, _from, {_last_call_time, :closed} = state) do
    {:reply, :ok, state}
  end

  def handle_info(:reopen, _state) do
    exec_rebuild()
    {:noreply, {time_now(), :open}}
  end

  # ----- Helpers

  @doc false
  def reopen do
    GenServer.call(__MODULE__, :reopen)
  end

  defp exec_rebuild do
    IO.puts("Rebuilding FTS Index")
    # Manager.reload()
  end

  defp time_now() do
    :erlang.system_time(:millisecond)
  end
end

