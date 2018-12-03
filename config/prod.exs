use Mix.Config

config :logger, level: :info

config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  secret_key_base: "3kqea5Qnw44Coi021eZTY7Ts+xx0iFpAUzhzuEMymI7o8ZzaBUEWwaYb2GLabffH",
  url: [host: System.get_env("HOSTNAME")],
  http: [port: 8888],
  https: [
    port: System.get_env("PORT"),
    keyfile: Path.expand(System.get_env("KEYFILE_PATH"), __DIR__),
    certfile: Path.expand(System.get_env("CERTFILE_PATH"), __DIR__)
  ],
  force_ssl: [hsts: true],
  check_origin: false,
  server: true

config :future_butcher_api, FutureButcherApi.Repo,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASSWORD"),
  database: System.get_env("DATABASE_NAME"),
  pool_size: 15
