defmodule MdTools.Fts.Svc.Manager do
  @moduledoc "Database Manager"

  # use GenServer
  #
  # # alias MdTools.Docs.Dir
  # alias MdTools.Fts.Db
  #
  # # ----- API
  #
  # @doc "Search the database"
  # def search(query) do
  #   GenServer.call(__MODULE__, {:search, query})
  # end
  #
  # @doc "Reload the database"
  # def reload do
  #   GenServer.call(__MODULE__, :reload)
  # end
  #
  # # ----- Startup
  #
  # @doc false
  # def start_link(_) do
  #   GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  # end
  #
  # @doc false
  # def init(_) do
  #   IO.puts("Starting FTS Manager")
  #   db = Db.open(":memory:")
  #        |> reload()
  #
  #   {:ok, db}
  # end
  #
  # # ----- Callbacks
  # #
  # def handle_call(:reload, _from, db) do
  #   reload(db)
  #   {:reply, :ok, db}
  # end
  #
  # def handle_call({:search, query}, _from, db) do
  #   results = search(db, query)
  #   {:reply, results, db}
  # end
  #
  # # ----- Helpers
  #
  # defp reload(db) do
  #   Db.empty(db)
  #   Db.load(db, md_data())
  # end
  #
  # defp search(db, query) do
  #   Db.search(db, query)
  # end
  #
  # defp md_data(dir \\ "/home/aleak/util/org") do
  #   dir
  #   # |> Dir.ingest()
  #   |> List.flatten()
  # end

end

