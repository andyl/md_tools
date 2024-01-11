defmodule MdTools.MixProject do
  use Mix.Project

  def project do
    [
      app: :md_tools,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:observer, :wx, :logger],
      mod: {MdTools.Application, []}
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.0"},
      {:exqlite, "~> 0.17"},
      {:file_system, "~> 0.2"}
    ]
  end
end
