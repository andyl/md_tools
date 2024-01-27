defmodule MdTools.Util.XmapTest do

  use ExUnit.Case

  alias MdTools.Util.Xmap

  describe "#assign/2" do
    test "basic assignment" do
      map = Xmap.assign(%{a: 1}, %{b: 2})
      assert map == %{a: 1, b: 2}
    end
  end

  describe "#assign/3" do
    test "description" do
      map = Xmap.assign(%{a: 1}, :b, 2)
      assert map == %{a: 1, b: 2}
    end
  end

  describe "#update/3" do
    test "description" do
      map = Xmap.update(%{a: 1}, :a, &(&1 + 1))
      assert map == %{a: 2}
    end
  end

end
