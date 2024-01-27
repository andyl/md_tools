defmodule MdTools.Svc.JobQueue do
  use GenServer

  # ----- API

  def submit(job_fn) do
    GenServer.cast(__MODULE__, {:jq_jobnew, job_fn})
  end

  def status() do
    GenServer.call(__MODULE__, :jq_status)
  end

  # ----- startup

  def start_link(opts \\ %{}) do
    default = Map.merge(%{active_job: nil, job_queue: []}, opts)
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  # ----- callbacks

  def handle_cast({:jq_jobnew, job_fn}, state) do
    newstate = case state.active_job do
      nil -> %{state | jobs: state.jobs ++ [job_fn]}
      _ -> %{state | active_job: job_fn} |> run_active_job()
    end
    {:noreply, newstate}
  end

  def handle_cast(:jq_jobdone, state) do
    newstate = case state.job_queue do
      [] ->
        %{state | active_job: nil}
      _ ->
        [head | tail] = state.job_queue
        state
        |> Map.put(:active_job, head)
        |> Map.put(:job_queue, tail)
        |> run_active_job()
    end

    {:noreply, newstate}
  end

  def handle_cast({:jq_subscribe, pid}, state) do
    newstate = %{state | subscribers: state.subscribers ++ [pid]}
    {:noreply, newstate}
  end

  def handle_call(:jq_status, state) do
    {:reply, state, state}
  end

  # ----- helpers

  def run_active_job(state) do
    spawn(fn ->
      state.active_job.()
      GenServer.cast(__MODULE__, :jq_jobdone)
    end)
    state
  end

end

