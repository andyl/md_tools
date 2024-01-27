defmodule MdTools.Doc.Svc.DocWatcherTest do

  use ExUnit.Case

  alias MdTools.Doc.Svc.DocWatcher

  @dir "/tmp/test_dir"

  describe "start_link/1" do
    test "starts the GenServer successfully" do
      setup()
      assert {:ok, _pid} = DocWatcher.start_link(basepath: @dir)
      teardown()
    end

    test "with start_supervised" do
      setup()
      assert {:ok, _pid} = start_supervised({DocWatcher, [basepath: @dir]})
      teardown()
    end

    test "with start_supervised!" do
      setup()
      assert start_supervised!({DocWatcher, [basepath: @dir]})
      teardown()
    end

    test "registered process name" do
      setup()
      start_supervised({DocWatcher, [basepath: @dir]})
      assert Process.whereis(:doc_watcher)
      teardown()
    end
  end

  def setup do
    File.mkdir_p(@dir)
  end

  def teardown do
    File.rm_rf(@dir)
  end
end
