import Config

config :secure_chat_backend, Core.Repo,
  database: "chat_test_testd",
  username: "postgres",
  password: "password",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox


config :logger, level: :error
config :secure_chat_backend, Core.Repo, log_level: :error
