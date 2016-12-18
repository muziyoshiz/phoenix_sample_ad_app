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
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
