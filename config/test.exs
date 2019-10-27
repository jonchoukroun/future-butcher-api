use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :future_butcher_api, FutureButcherApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "future_butcher_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :bcrypt_elixir, :log_rounds, 4