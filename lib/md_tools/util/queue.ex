defmodule MdTools.Util.Queue do

  def from_list(list) do
    :queue.from_list(list)
  end

  def to_list(queue) do
    :queue.to_list(queue)
  end

  def push(queue, element) do
    :queue.in(element, queue)
  end

  def pop(queue) do
    {{:value, head}, tail} = :queue.out(queue)
    {head, tail}
  end

  def peek(queue) do
    {:value, head} = :queue.peek(queue)
    head
  end

  def filter(queue, func) do
    :queue.filter(fn item -> func.(item) end, queue)
  end

  def is_empty?(queue) do
    ! :queue.is_empty(queue)
  end

  def length(queue) do
    :queue.len(queue)
  end

end
