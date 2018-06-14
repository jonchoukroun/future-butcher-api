use Mix.Config

config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  http: [port: 4000],
  url: [host: "futurebutcher.com", port: 80],
  https: [
    port: 443,
    keyfile: Path.expand("/etc/letsencrypt/live/futurebutcher.com/privkey.pem"),
    certfile: Path.expand("/etc/letsencrypt/live/futurebutcher.com/fullchain.pem")
  ],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  server: true,
  root: ".",
  code_reloader: false,
  version: Application.spec(:future_butcher_api, :vsn)

# Do not print debug messages in production
config :logger, level: :info

import_config "prod.secret.exs"
