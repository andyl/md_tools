defmodule MdTools.Cache.Svc.JsonStageTest do

  use ExUnit.Case

  alias MdTools.Cache.Svc.JsonStage
  alias MdTools.Doc.Svc.DocStage
  alias MdTools.Util.DemoConsumer

  import MdTools.Util.Test

  @dir_base MdTools.Util.Test.base_dir()
  @dir_test MdTools.Util.Test.test_dir()

  describe "start_link/1" do
    test "starts the GenServer" do
      setup()
      assert {:ok, _pid} = JsonStage.start_link(base_dir: @dir_base)
    end

    test "with start_supervised" do
      setup()
      assert {:ok, _pid} = start_supervised({JsonStage, [base_dir: @dir_base]})
    end

    test "with start_supervised!" do
      setup()
      assert start_supervised!({JsonStage, [base_dir: @dir_base]})
    end

    test "registered process name" do
      setup()
      start_supervised({JsonStage, [base_dir: @dir_base]})
      assert Process.whereis(:json_stage)
    end

    test "with no arguments" do
      setup()
      start_supervised({JsonStage, []})
      assert Process.whereis(:json_stage)
    end

  end

  describe "subscribe" do
    test "link from consumer to producer with dir_base" do
      setup()
      {:ok, doc}      = DocStage.start_link(base_dir: @dir_base)
      {:ok, cache}    = JsonStage.start_link(base_dir: @dir_base)
      {:ok, consumer} = DemoConsumer.start_link()
      GenStage.sync_subscribe(cache,    to: doc,   min_demand: 2, max_demand: 4)
      GenStage.sync_subscribe(consumer, to: cache, min_demand: 2, max_demand: 4)
      assert_receive({:events, _events}, 500)
      # IO.inspect(events, label: "DEMO_CONSUMER_BASE")
      assert {doc, cache, consumer}
    end

    test "link from consumer to producer with dir_test" do
      setup()
      {:ok, doc}      = DocStage.start_link(base_dir: @dir_test)
      {:ok, cache}    = JsonStage.start_link(base_dir: @dir_test)
      {:ok, consumer} = DemoConsumer.start_link()
      GenStage.sync_subscribe(cache,    to: doc,   min_demand: 2, max_demand: 4)
      GenStage.sync_subscribe(consumer, to: cache, min_demand: 2, max_demand: 4)
      assert_receive({:events, _events}, 500)
      # IO.inspect(events, label: "DEMO_CONSUMER_TEST")
      assert {doc, cache, consumer}
    end
  end

  # describe "stream" do
  # end

end
