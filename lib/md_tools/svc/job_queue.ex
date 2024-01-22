defmodule MdTools.Svc.JobQueue do
  use GenServer

  # ----- API

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def submit(job) do
    GenServer.cast(__MODULE__, {:submit, job})
  end

  def status() do
    GenServer.call(__MODULE__, :status)
  end

  def subscribe(pid) do
    GenServer.cast(__MODULE__, {:subscribe, pid})
  end

  # ----- Callbacks

  def init(_initial_state) do
    {:ok, %{jobs: [], subscribers: []}}
  end

  def handle_cast({:submit, job}, state) do
    new_state = %{state | jobs: state.jobs ++ [job]}
    {:noreply, new_state}
  end

  def handle_cast({:subscribe, pid}, state) do
    new_state = %{state | subscribers: state.subscribers ++ [pid]}
    {:noreply, new_state}
  end

  def handle_call(:status, _from, state) do
    {:reply, state.jobs, state}
  end

  # Implement job processing and notification logic here
end

