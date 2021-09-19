use Mix.Config

config :phoenix, :json_library, Jason

config :logger, level: :warn
config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :exq,
  start_on_application: true,
  max_retries: 2,
  queues: [
    {"email", 2},
    {"default", 2},
    {"failed", 1}
  ],
  middleware: [
    Exq.Middleware.Stats,
    Exq.Middleware.Job,
    Exq.Middleware.Manager
  ]
