# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :elixir_playground_api,
  ecto_repos: [ElixirPlaygroundApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :elixir_playground_api, ElixirPlaygroundApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: ElixirPlaygroundApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ElixirPlaygroundApi.PubSub,
  live_view: [signing_salt: "yei6SMfu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :elixir_playground_api, ElixirPlaygroundApiWeb.Auth.Guardian,
  issuer: "elixir_playground_api",
  secret_key: "q0uyNqjuDrlMRqOwI5Z64oQt2zZO4g/Ql71hrzJkt8qiA46VlkknAtZqyycTGTx+"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian.DB,
    repo: ElixirPlaygroundApi.Repo,
    schema_name: "guardian_tokens",
    sweep_interval: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
