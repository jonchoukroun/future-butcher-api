# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

config :future_butcher_api, FutureButcherInterface.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "future_butcher_interface",
  hostname: "localhost"

# General application configuration
config :future_butcher_api,
  ecto_repos: [FutureButcherApi.Repo]

config :phoenix, :json_library, Jason

# Configures the endpoint
config :future_butcher_api, FutureButcherApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3HY7w2nrfM4XpDMVYTU57/0iqfIlq5q+IydM8jryVNZpMS+XKWSDHWxvKev7eBfS",
  render_errors: [view: FutureButcherApiWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: FutureButcherApi.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :sentry,
  dsn: "https://public_key@app.getsentry.com/1",
  environment_name: Mix.env(),
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  tags: %{
    env: "production"
  }

config :logger, Sentry.LoggerBackend,
  capture_log_messages: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
