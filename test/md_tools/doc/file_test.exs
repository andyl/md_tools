defmodule MdTools.Doc.FileTest do

  use ExUnit.Case


  alias MdTools.Doc.File
  alias MdTools.Doc.Section
  alias MdTools.Util.Test

  describe "#ingest/2" do
    test "from test file" do
      output = Test.test_file() |> File.ingest()
      assert output |> is_list()
      assert output |> length() == 3
    end

    test "data elements" do
      output = Test.test_file() |> File.ingest()
      head = output |> List.first()
      assert %Section{} = head
      assert head.doctitle != ""
      assert head.filepath != ""
      assert head.startline == 1
    end
  end

end
