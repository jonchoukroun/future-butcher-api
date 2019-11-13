import Config

config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  http: [port: System.fetch_env!("APP_PORT")],
  url: [host: "api.futurebutcher.com"],
  check_origin: false,
  server: true

config :future_butcher_api, FutureButcherApi.Repo,
  username: System.fetch_env!("DATABASE_USER"),
  password: System.fetch_env!("DATABASE_PASSWORD"),
  database: System.fetch_env!("DATABASE_NAME"),
  pool_size: 15

config :sentry,
  dsn: System.fetch_env!("SENTRY_DSN_KEY"),
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  tags: %{
    env: "production"
  },
  included_environments: [:prod]
