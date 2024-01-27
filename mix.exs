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
      # ----- basics
      {:jason, "~> 1.4"},
      {:bandit, "~> 1.0"},
      {:exqlite, "~> 0.18"},
      {:file_system, "~> 1.0"},
      {:gen_stage, "~> 1.2"},
      {:uniq, "~> 0.6"},
      # ----- tensor operations
      {:nx, "~> 0.6"},
      {:exla, "~> 0.6"},
      {:bumblebee, "~> 0.4"},
      # ----- testing
      {:mix_test_interactive, path: "~/src/Forks/mix_test_interactive", only: :dev, runtime: false}
    ]
  end
end
