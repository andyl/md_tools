defmodule MdTools.Doc.Svc.WatcherTest do

  use ExUnit.Case

  alias MdTools.Doc.Svc.Watcher

  @dir "/tmp/test_dir"

  describe "start_link/1" do
    test "starts the GenServer successfully" do
      setup()
      assert {:ok, _pid} = Watcher.start_link(base_dir: @dir)
      teardown()
    end

    test "with start_supervised" do
      setup()
      assert {:ok, _pid} = start_supervised({Watcher, [base_dir: @dir]})
      teardown()
    end

    test "with start_supervised!" do
      setup()
      assert start_supervised!({Watcher, [base_dir: @dir]})
      teardown()
    end

    test "registered process name" do
      setup()
      start_supervised({Watcher, [base_dir: @dir]})
      assert Process.whereis(:doc_watcher)
      teardown()
    end
  end

  # ----- helpers

  def setup do
    File.mkdir_p(@dir)
  end

  def teardown do
    File.rm_rf(@dir)
  end
end
