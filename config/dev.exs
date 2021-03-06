import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  http: [port: 5000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :future_butcher_api, FutureButcherApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "future_butcher_api_dev",
  hostname: "localhost",
  pool_size: 10
