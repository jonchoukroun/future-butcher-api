use Mix.Config

config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  http: [port: 4000],
  url: [host: "futurebutcher.com", port: 80],
  server: true,
  root: ".",
  code_reloader: false

# Do not print debug messages in production
config :logger, level: :info

import_config "prod.secret.exs"
