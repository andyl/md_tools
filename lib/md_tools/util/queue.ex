defmodule MdTools.Util.Queue do

  def new do
    :queue.new()
  end

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

  def pop(queue, count) when is_number(count) do
    do_pop([], queue, count, len(queue))
  end

  defp do_pop(head, tail, 0, _), do: {head, tail}
  defp do_pop(head, tail, _, 0), do: {head, tail}

  defp do_pop(head, tail, count, _len) do
    {new_head, new_tail} = pop(tail)
    do_pop(head ++ [new_head], new_tail, count - 1, len(new_tail))
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

  def len(queue) do
    :queue.len(queue)
  end

end
