# test/md_tools/util/demo_consumer_test.exs
defmodule MdTools.Util.DemoConsumerTest do

  use ExUnit.Case

  alias MdTools.Util.DemoConsumer
  alias MdTools.Doc.Svc.DocStage

  import MdTools.Util.Test

  @dir "/tmp/test_dir"

  describe "start_link/1" do
    test "starts the GenServer successfully" do
      setup()
      assert {:ok, _pid} = DemoConsumer.start_link()
      teardown()
    end

    test "with start_supervised" do
      setup()
      assert {:ok, _pid} = start_supervised({DemoConsumer, []})
      teardown()
    end

    test "with start_supervised!" do
      setup()
      assert start_supervised!({DemoConsumer, []})
      teardown()
    end

    test "registered process name" do
      setup()
      start_supervised({DemoConsumer, []})
      assert Process.whereis(:demo_consumer)
      teardown()
    end

    test "with no arguments" do
      setup()
      start_supervised({DemoConsumer, []})
      assert Process.whereis(:demo_consumer)
      teardown()
    end
  end

  describe "subscribe" do
    test "link from consumer to producer" do
      setup()
      {:ok, producer} = DocStage.start_link(base_dir: @dir)
      {:ok, consumer} = DemoConsumer.start_link()
      GenStage.sync_subscribe(consumer, to: producer, min_demand: 2, max_demand: 4)
      assert_receive({:events, _events}, 500)
      # IO.inspect(events, label: "DEMO_CONSUMER")
      teardown()
    end
  end

end
