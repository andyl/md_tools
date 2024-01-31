defmodule MdTools.SearchFts.DbTest do
  use ExUnit.Case

  alias MdTools.SearchFts.Db
  alias MdTools.Doc.Section

  describe "#open/0" do

    test "an in-memory database" do
      conn = Db.open()
      assert conn
    end

    test "an on-file database" do
      dbpath = "/home/aleak/killme.db"
      File.rm_rf(dbpath)
      conn = Db.open(dbpath)
      assert conn
    end

  end

  describe "#select_all/1" do

    test "from empty database" do
      result =
        Db.open()
        |> Db.select_all()

      assert is_list(result)
    end

  end

  describe "#load_row/2" do

    test "one single row" do
      dbpath = "/home/aleak/killme.db"
      File.rm_rf(dbpath)
      conn = Db.open(dbpath)
      result = Db.load_row(conn, %Section{}) |> Db.select_all()
      assert result
    end

    test "two row" do
      dbpath = "/home/aleak/killme.db"
      File.rm_rf(dbpath)
      conn = Db.open(dbpath)
      Db.load_row(conn, %Section{doctitle: "ONE"})
      Db.load_row(conn, %Section{doctitle: "TWO"})
      result = Db.select_all(conn)
      assert result
    end

  end

  describe "#search/2" do

    test "basic search" do
      dbpath = "/home/aleak/killme.db"
      File.rm_rf(dbpath)
      conn = Db.open(dbpath)
      Db.load_row(conn, %Section{doctitle: "ONE", body: "TICK bing"})
      Db.load_row(conn, %Section{doctitle: "TWO", body: "TOCK bong "})
      Db.load_row(conn, %Section{doctitle: "THREE", body: "TICK pong"})
      result = Db.search(conn, "pong")
      assert result
    end

  end
end
