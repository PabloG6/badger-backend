use Mix.Config

# Configure your database
config :badger_api, BadgerApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "badger_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :badger_api, BadgerApiWeb.Endpoint,
  http: [port: 4002],
  server: false

config :bcrypt_elixir, :log_rounds, 4


# Print only warnings and errors during test
config :logger, level: :warn


