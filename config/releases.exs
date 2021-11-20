import Config

ssl_cert_path = System.fetch_env!("SSL_CERT_PATH")

config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  http: [port: System.fetch_env!("HTTP_PORT")],
  url: [host: "api.futurebutcher.com"],
  https: [
    port: String.to_integer(System.fetch_env!("HTTPS_PORT")),
    keyfile: Path.absname("#{ssl_cert_path}privkey.pem"),
    certfile: Path.absname("#{ssl_cert_path}cert.pem"),
    cacertfile: Path.absname("#{ssl_cert_path}chain.pem")
  ],
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
