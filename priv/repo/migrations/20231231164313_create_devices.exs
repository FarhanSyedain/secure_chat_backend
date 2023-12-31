defmodule Core.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :device_id, :integer
      add :last_resort_pre_key, :string
      add :token, :string
      add :token_salt, :string
      add :gcm, :string
      add :apn, :string
      add :uuid, :string

      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
