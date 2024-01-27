import Config

config :nx, [
  default_backend: EXLA.Backend,
  default_defn_options: [compiler: EXLA]
]

config :exla, [
  default_client: :cuda,
  clients: [
    host: [platform: :host],
    cuda: [platform: :cuda]
  ]
]

System.put_env([
  XLA_TARGET: "cuda120",
  TF_CPP_MIN_LOG_LEVEL: 3]
)

if Mix.env == :dev do
  config :mix_test_interactive, clear: true
end

