# defmodule MdTools.Svc.JobQueueTest do
#   use ExUnit.Case
#
#   alias MdTools.Svc.JobQueue
#
#   doctest JobQueue
#
#   describe "start_link/1" do
#     test "starts the GenServer successfully" do
#       assert {:ok, _pid} = JobQueue.start_link()
#     end
#
#     test "initializes with an empty job list" do
#       {:ok, pid} = JobQueue.start_link()
#       assert GenServer.call(pid, :status) == []
#     end
#
#     test "can initialize with a predefined job list" do
#       initial_jobs = ["job1", "job2"]
#       {:ok, pid} = JobQueue.start_link(initial_jobs)
#       assert GenServer.call(pid, :status) == initial_jobs
#     end
#   end
#
#   describe "submit/1" do
#     test "enqueues a new job" do
#       {:ok, pid} = JobQueue.start_link()
#       JobQueue.submit("new_job")
#       assert GenServer.call(pid, :status) == ["new_job"]
#     end
#
#     test "enqueues multiple jobs" do
#       {:ok, pid} = JobQueue.start_link()
#       JobQueue.submit("job1")
#       JobQueue.submit("job2")
#       assert GenServer.call(pid, :status) == ["job1", "job2"]
#     end
#
#     test "handles empty job submission" do
#       {:ok, pid} = JobQueue.start_link()
#       JobQueue.submit("")
#       assert GenServer.call(pid, :status) == [""]
#     end
#   end
#
#   describe "status/0" do
#     test "returns an empty list for a new GenServer" do
#       {:ok, pid} = JobQueue.start_link()
#       assert JobQueue.status() == []
#     end
#
#     test "returns the current job list" do
#       {:ok, pid} = JobQueue.start_link()
#       JobQueue.submit("job1")
#       assert JobQueue.status() == ["job1"]
#     end
#
#     test "returns an updated job list after multiple submissions" do
#       {:ok, pid} = JobQueue.start_link()
#       JobQueue.submit("job1")
#       JobQueue.submit("job2")
#       assert JobQueue.status() == ["job1", "job2"]
#     end
#   end
#
#   describe "subscribe/1" do
#     test "subscribes a process to the job queue" do
#       {:ok, pid} = JobQueue.start_link()
#       send(pid, {:subscribe, self()})
#       # You would normally check that the PID is in the subscribers list
#       # This requires modifying the JobQueue to expose this information for testing
#       assert_receive {:subscribed, ^pid}
#     end
#
#     test "subscribes multiple processes" do
#       {:ok, pid} = JobQueue.start_link()
#       send(pid, {:subscribe, self()})
#       send(pid, {:subscribe, self()})
#       assert_receive {:subscribed, ^pid}
#       assert_receive {:subscribed, ^pid}
#     end
#
#     test "handles subscription of invalid PIDs" do
#       {:ok, pid} = JobQueue.start_link()
#       send(pid, {:subscribe, nil})
#       # Verify that no crash occurs and the system handles it gracefully
#       # This might require additional implementation in the JobQueue
#       assert_receive {:subscribed, ^pid}
#     end
#   end
# end
#
