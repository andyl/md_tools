defmodule MdTools.Vss.Embed do
  def serving do
    {:ok, model_info} = Bumblebee.load_model({:hf, "sentence-transformers/all-MiniLM-L6-v2"})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "sentence-transformers/all-MiniLM-L6-v2"})

    Bumblebee.Text.TextEmbedding.text_embedding(model_info, tokenizer,
      output_pool: :mean_pooling,
      output_attribute: :hidden_state,
      embedding_processor: :l2_norm
    )
  end

  def gen(text) do
    serving()
    |> Nx.Serving.run(text)
  end

  def to_json(tensor) do
    tensor
    |> Nx.to_list()
    |> Jason.encode!()
  end

  def json_batch(list) when is_list(list) do
    serving = serving()
    json_batch(list, serving)
  end

  def json_batch(list, serving) when is_list(list) do
    list
    |> Enum.map(fn item -> json_batch(item, serving) end)
  end

  def json_batch(element, serving) do
    clean = case element do
      [] -> ""
      vx -> vx
    end
    serving
    |> Nx.Serving.run(clean)
    |> Map.get(:embedding)
    |> Nx.to_list()
    |> Jason.encode!()
  end
end
