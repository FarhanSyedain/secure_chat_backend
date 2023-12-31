import Config

config :secure_chat_backend, Core.Repo,
  database: "chat_test",
  username: "postgres",
  password: "password",
  hostname: "localhost"

config :secure_chat_backend, ecto_repos: [Core.Repo]
