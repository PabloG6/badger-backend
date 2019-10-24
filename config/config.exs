# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :badger_api, BadgerApi.Auth.Guardian,
  issuer: "badger_api",
  secret_key: "76vUtNm17w3oL2DcL1qj7ky5zZljwxqjn/A3EY6K7tJtargfOUqu5fCjPFEkqbAq"

config :badger_api,
  ecto_repos: [BadgerApi.Repo]

# Configures the endpoint
config :badger_api, BadgerApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "StjSK3Ten/ww1E7E1OqYIj+nETzxGdNAHljxX6b5Z6xv0Vx71JrynZUVcYzx9apY",
  render_errors: [view: BadgerApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BadgerApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :arc,
  storage: Arc.Storage.GCS,
  bucket: "badger-testing",
  config: :goth,
  json: {:system, "GOOGLE_APPLICATION_CREDENTIALS"}

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure search module for api
config :search,
  hostname: "localhost",
  port: 8983,
  core: "badger_search"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
