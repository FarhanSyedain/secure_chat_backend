defmodule Core.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone_number, :string
      add :uuid, :string
      add :registration_lock, :string
      add :registration_salt, :string
      add :identity_key, :string
    end
  end
end
