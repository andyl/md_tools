defmodule MdTools.Util.Test do

  @dir "/tmp/test_dir"

  def base_dir, do: @dir

  def test_dir do
    "/home/aleak/src/md_tools/data"
  end

  def test_file do
    "/home/aleak/src/md_tools/data/TopMOC.md"
  end

  def test_text do
    test_file() |> File.read!()
  end

  def org_dir do
    "/home/aleak/util/org"
  end

  def org_file do
    "/home/aleak/util/org/OrgMOC.md"
  end

  def org_text do
    org_file() |> File.read!()
  end

  # -----

  def setup do
    File.rm_rf(@dir)
    File.mkdir_p(@dir)
    File.mkdir_p(@dir <> "/.md_tools")
    File.write("#{@dir}/test1.md", "TestData")
  end

  def teardown do
    File.rm_rf(@dir)
  end

end
