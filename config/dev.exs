use Mix.Config

config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []
  
config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :future_butcher_api, FutureButcherApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "future_butcher_api_dev",
  hostname: "localhost",
  pool_size: 10

config :cipher,
  keyphrase: "secretdevkeyphrase",
  ivphrase: "secretdevivphrase",
  magic_token: "secretdevmagictoken"
