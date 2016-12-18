# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_sample_ad_app,
  ecto_repos: [PhoenixSampleAdApp.Repo]

# Configures the endpoint
config :phoenix_sample_ad_app, PhoenixSampleAdApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bvSZBCXcR0W8MgCxQYIHBMsJQyURgbnrKVxvkHvcSIvtEI2dqzmTwoFOpvTZ7tcU",
  render_errors: [view: PhoenixSampleAdApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixSampleAdApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
#config :logger, :console,
#  format: "$time $metadata[$level] $message\n",
#  metadata: [:request_id]

config :logger,
  backends: [{LoggerFileBackend, :access_log}, {LoggerFileBackend, :debug_log}]

config :logger, :access_log,
  path: "log/access.log",
  level: :info,
  format: "$date $time\t$message\n",
  metadata_filter: [access_log: true]

config :logger, :debug_log,
  path: "log/debug.log",
  level: :debug,
  format: "$date $time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
