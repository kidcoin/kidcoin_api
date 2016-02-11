use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kidcoin_api, KidcoinApi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :kidcoin_api, KidcoinApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "bj",
  password: "",
  database: "kidcoin_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
