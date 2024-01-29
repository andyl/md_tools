defmodule MdTools.Cache.Svc.JsonStage do

  use GenStage

  @moduledoc "For ingesting documents - a GenStage consumer/producer."

  @procname :json_stage

  alias MdTools.Cache.JsonIO
  alias MdTools.Util.Test
  alias MdTools.Doc

  import MdTools.Util.Xmap

  # ----- startup

  @doc "Start the JsonStage server"
  def start_link(options \\ []) when is_list(options) do
    GenStage.start_link(__MODULE__, options, name: @procname)
  end

  @doc false
  @impl true
  def init(options) do
    state = init_state(options)
    setup_cache_assets(state)
    {:producer_consumer, state}
  end

  # ----- callbacks

  @impl true
  def handle_events(events, _from, state) do
    delta_events = calculate_deltas(state.cache_data, events)
    new_cache  = apply_deltas(delta_events, state.cache_data)
    {:noreply, delta_events, assign(state, :cache_data, new_cache)}
  end

  # ----- init helpers

  def default_state do
    %{
      base_dir: Test.base_dir(),
      cache_dir: "TBD",
      cache_file: "TBD",
      cache_data: [],
    }
  end

  def init_state(options) do
    state = default_state() |> Map.merge(Enum.into(options, %{}))
    cache_dir = Path.join(state.base_dir, "/.md_tools")
    cache_base = Path.basename(state.base_dir)
    cache_file = Path.join(cache_dir, "#{cache_base}.ndjson")
    cache_data = JsonIO.read(cache_file)

    state
    |> assign(:cache_dir , cache_dir)
    |> assign(:cache_file, cache_file)
    |> assign(:cache_data, cache_data)
  end

  def setup_cache_assets(state) do
    File.mkdir_p(state.cache_dir)
    File.touch(state.cache_file)
  end

  # ----- generate delta events

  def calculate_deltas(cache, events) do
    events
    |> Enum.map(fn event -> gen_delta(cache, event) end)
    |> List.flatten()
  end

  def gen_delta(cache, {:delete, _path, _mtime} = event) do
    case in_cache?(cache, event) do
      true -> emit_remove_event(event)
      false -> []
    end
  end

  def gen_delta(cache, event) do
    cond do
      not_in_cache?(cache, event)   -> emit_append_event(event)
      newly_modified?(cache, event) -> [emit_remove_event(event), emit_append_event(event)]
      true -> []
    end
  end

  # ----- gen delta predicates

  def not_in_cache?(cache, {:upsert, path, _mtime}) do
    Enum.all?(cache, fn item -> item.filepath != path end)
  end

  def in_cache?(cache, {:upsert, _path, _mtime} = event) do
    ! not_in_cache?(cache, event)
  end

  def newly_modified?(cache, {:upsert, path, mtime}) do
    {cache, path, mtime}
  end

  # ----- delta event emitters

  def emit_append_event({:upsert, path, _mtime}) do
    {:append, Doc.File.ingest(path)}
  end

  def emit_remove_event({_action, path, _mtime}) do
    {:remove, path}
  end

  # ----- delta event appliers

  def apply_deltas(cache, deltas) do
    # Enum.filter(cache, fn item -> path == item.filepath end)
    {cache, deltas}
  end

  def apply_delta({:upsert, path, mdate}, state) do
    {path, mdate, state}
  end

  def apply_delta({:delete, path, mdate}, state) do
    {path, mdate, state}
  end

end
