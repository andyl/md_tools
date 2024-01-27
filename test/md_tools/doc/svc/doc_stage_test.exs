defmodule MdTools.Doc.Svc.DocStageTest do
  use ExUnit.Case

  alias MdTools.Doc.Svc.DocStage
  alias MdTools.Util.Queue

  @dir "/tmp/test_dir"

  describe "start_link/1" do
    test "starts the GenServer successfully" do
      setup()
      assert {:ok, _pid} = DocStage.start_link(base_dir: @dir)
      teardown()
    end

    test "with start_supervised" do
      setup()
      assert {:ok, _pid} = start_supervised({DocStage, [base_dir: @dir]})
      teardown()
    end

    test "with start_supervised!" do
      setup()
      assert start_supervised!({DocStage, [base_dir: @dir]})
      teardown()
    end

    test "registered process name" do
      setup()
      start_supervised({DocStage, [base_dir: @dir]})
      assert Process.whereis(:doc_stage)
      teardown()
    end

    test "with no arguments" do
      setup()
      start_supervised({DocStage, []})
      assert Process.whereis(:doc_stage)
      teardown()
    end
  end

  describe "#base_dir/0" do
    test "with default path" do
      start_supervised(DocStage)
      assert "/home/aleak/util/org" == DocStage.base_dir()
    end

    test "with alternate path" do
      setup()
      start_supervised({DocStage, [base_dir: @dir]})
      assert @dir == DocStage.base_dir()
    end
  end

  describe "#collection_name/0" do
    test "with default path" do
      start_supervised(DocStage)
      assert "org" == DocStage.collection_name()
    end
  end

  describe "#event_queue/0" do
    test "getting the list " do
      start_supervised(DocStage)
      docs = DocStage.event_queue()
      assert Queue.len(docs) > 20
    end
  end

  describe "#upsert_file/1" do
    test "insert new filepath" do
      setup()
      start_supervised({DocStage, [base_dir: @dir]})
      DocStage.upsert_file("#{@dir}/test2.md")
      doclist = DocStage.event_queue()
      assert Queue.len(doclist) == 2
      teardown()
    end

    test "insert existing filepath" do
      setup()
      start_supervised({DocStage, [base_dir: @dir]})
      DocStage.upsert_file("#{@dir}/test1.md")
      doclist = DocStage.event_queue()
      assert Queue.len(doclist) == 1
      teardown()
    end
  end

  describe "#delete_file/1" do
    test "delete new filepath" do
      setup()
      start_supervised({DocStage, [base_dir: @dir]})
      DocStage.delete_file("#{@dir}/test2.md")
      doclist = DocStage.event_queue()
      assert Queue.len(doclist) == 2
      teardown()
    end

    test "delete existing filepath" do
      setup()
      start_supervised({DocStage, [base_dir: @dir]})
      DocStage.delete_file("#{@dir}/test1.md")
      doclist = DocStage.event_queue()
      assert Queue.len(doclist) == 1
      teardown()
    end

  end

  describe "#handle_demand/2" do
    test "when demand count == 1" do
      setup()
      start_supervised({DocStage, [base_dir: @dir]})
      {:noreply, val, state} = DocStage.handle_demand(1, DocStage.state())
      assert length(val) == 1
      assert Queue.len(state.event_queue) == 0
      teardown()
    end
  end

  # ----- helpers

  def setup do
    File.mkdir_p(@dir)
    File.write("#{@dir}/test1.md", "TestData")
  end

  def teardown do
    File.rm_rf(@dir)
  end
end
