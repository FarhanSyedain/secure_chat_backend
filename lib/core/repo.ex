defmodule Core.Repo do
  use Ecto.Repo,
    otp_app: :secure_chat_backend,
    adapter: Ecto.Adapters.Postgres
end
