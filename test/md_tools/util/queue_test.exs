defmodule MdTools.Util.QueueTest do

  use ExUnit.Case

  alias MdTools.Util.Queue

  describe "#from_list/1" do
    test "makes a simple queue" do
      list = [1,2,3]
      assert Queue.from_list(list) == :queue.from_list(list)
    end
  end

  describe "#to_list/1" do
    test "converts back to list" do
      list1 = [1,2,3]
      list2 = list1 |> Queue.from_list() |> Queue.to_list()
      assert list1 == list2
    end
  end

  describe "#push/2" do
    test "adds an item to the tail" do
      list1 = [1,2,3]
      queue = Queue.from_list(list1)
      list2  = queue |> Queue.push(4) |> Queue.to_list()
      assert list2 == [1,2,3,4]
    end
  end

  describe "#pop/1" do
    test "removes a item from the queue" do
      {head, tail}  = [1,2,3] |> Queue.from_list() |> Queue.pop()
      assert Queue.len(tail) == 2
      assert head == 1
    end
  end

  describe "#pop/2" do
    test "removes zero item from the queue" do
      {head, tail}  = [1,2,3] |> Queue.from_list() |> Queue.pop(0)
      assert Queue.len(tail) == 3
      assert head == []
    end

    test "removes one item from the queue" do
      {head, tail}  = [1,2,3] |> Queue.from_list() |> Queue.pop(1)
      assert Queue.len(tail) == 2
      assert head == [1]
    end

    test "removes two item from the queue" do
      {head, tail}  = [1,2,3] |> Queue.from_list() |> Queue.pop(2)
      assert Queue.len(tail) == 1
      assert head == [1, 2]
    end

    test "removes three item from the queue" do
      {head, tail}  = [1,2,3] |> Queue.from_list() |> Queue.pop(3)
      assert Queue.len(tail) == 0
      assert head == [1, 2, 3]
    end

    test "removes five item from the queue" do
      {head, tail}  = [1,2,3] |> Queue.from_list() |> Queue.pop(5)
      assert Queue.len(tail) == 0
      assert head == [1, 2, 3]
    end
  end

  describe "#peek/1" do
    test "return the head" do
      result = [1,2,3] |> Queue.from_list() |> Queue.peek()
      assert result == 1
    end
  end

  describe "#filter/2" do
    test "remove an item" do
      q1 = [1,2,3] |> Queue.from_list()
      q2 = q1 |> Queue.filter(fn item -> item != 2 end)
      assert Queue.to_list(q2) == [1, 3]
    end
  end

  describe "#is_empty/1" do
    test "empty queue" do
      result = [] |> Queue.from_list() |> Queue.is_empty?()
      refute result
    end

    test "non-empty queue" do
      result = [1,2,3] |> Queue.from_list() |> Queue.is_empty?()
      assert result
    end
  end

  describe "#len/1" do
    test "empty queue" do
      result = [] |> Queue.from_list() |> Queue.len()
      assert result == 0
    end

    test "non-empty queue" do
      result = [1,2,3] |> Queue.from_list() |> Queue.len()
      assert result == 3
    end
  end

 end
