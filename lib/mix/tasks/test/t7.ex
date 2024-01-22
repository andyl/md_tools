defmodule Mix.Tasks.Test.T7 do
  use Mix.Task

  alias MdTools.Docs.Dir
  alias MdTools.Vss.Db

  def run(_) do
    System.put_env("XLA_TARGET", "cuda120")
    System.put_env("TF_CPP_MIN_LOG_LEVEL", "3")

    Mix.Task.run("app.start", ["--preload-modules"])

    data = "/home/aleak/util/org"
    |> Dir.ingest()
    |> List.flatten()

    data1 = data |> List.first()

    Db.open(":memory:")
    |> Db.load_row(data1)
    |> IO.inspect()

  end
end
