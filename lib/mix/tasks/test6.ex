defmodule Mix.Tasks.Test6 do
  use Mix.Task

  alias MdTools.ProcDir
  alias MdTools.Db

  def run(_) do
    data = "/home/aleak/util/org"
    |> ProcDir.ingest()
    |> List.flatten()

    db = Db.open(":memory:")

    Db.load(db, data)

    Db.search(db, "Plasma")
    |> IO.inspect()
  end
end
