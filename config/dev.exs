import Config

config :secure_chat_backend, Core.Repo,
  database: "chat_test",
  username: "postgres",
  password: "password",
  hostname: "localhost"


config :logger, level: :debug
