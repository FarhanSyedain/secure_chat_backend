import Config

config :secure_chat_backend, ecto_repos: [Core.Repo]

import_config "#{config_env()}.exs"
