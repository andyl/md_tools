defmodule MdTools.Doc.SectionTest do

  use ExUnit.Case

  alias MdTools.Doc.Section
  alias MdTools.Util.Test

  describe "Section Struct" do
    test "creation with default values" do
      sec = %Section{}
      assert sec.doctitle
      assert sec.sectitle
      assert sec.body
      assert sec.filepath
      assert sec.startline
      assert sec.uuid
      assert sec.updated
      assert sec.filehash
      assert sec.bodyhash
    end

    test "creation with specified values" do
      sec = %Section{doctitle: "xxx", body: "xxx", startline: 22, filehash: "xxx"}
      assert sec.doctitle
      assert sec.sectitle
      assert sec.body
      assert sec.filepath
      assert sec.startline
      assert sec.uuid
      assert sec.updated
      assert sec.filehash
      assert sec.bodyhash
    end
  end

  describe "#ingest/2" do
    test "from test file" do
      output = Test.test_text() |> Section.ingest()
      assert output |> is_list()
      assert output |> length() == 3
    end

    test "data elements" do
      output = Test.test_text() |> Section.ingest()
      head = output |> List.first()
      assert %Section{} = head
      assert head.doctitle != ""
      assert head.startline == 1
    end
  end

end
