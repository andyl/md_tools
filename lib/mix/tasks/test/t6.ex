defmodule Mix.Tasks.Test.T6 do
  use Mix.Task

  alias MdTools.Split.Dir
  alias MdTools.Fts.Db

  def run(_) do
    data = "/home/aleak/util/org"
    |> Dir.ingest()
    |> List.flatten()

    db = Db.open(":memory:")
    Db.load(db, data)

    Db.search(db, "Plasma")
    |> IO.inspect()
  end
end
