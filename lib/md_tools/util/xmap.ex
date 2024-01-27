defmodule MdTools.Util.Xmap do

  def assign(map1, map2) when is_map(map2) do
    Map.merge(map1, map2)
  end

  def assign(map, key, val) do
    Map.put(map, key, val)
  end

  def update(map, key, func) do
    Map.update!(map, key, func)
  end
end

