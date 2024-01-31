defmodule MdTools.Util.DbFtsTest do

  use ExUnit.Case

  alias MdTools.Util.DbFts
  alias MdTools.Doc.Section

  describe "#myfunc/1" do
    test "description" do
      assert DbFts
    end
  end

  describe "#create_data_table/2" do
    test "generate command" do
      string = %Section{} |> DbFts.create_data_table("sections")
      assert string
    end
  end

  # describe "#create_data_table/2" do
  #   test "generate command" do
  #     string = %Section{} |> DbFts.create_data_table("sections")
  #     assert string
  #   end
  # end

end
