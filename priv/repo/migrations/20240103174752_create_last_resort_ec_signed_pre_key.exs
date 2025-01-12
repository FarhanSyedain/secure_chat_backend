defmodule Core.Repo.Migrations.CreateLastResortEcSignedPreKey do
  use Ecto.Migration

  def change do
    create table(:last_resort_ec_signed_pre_keys) do
      add :key, :string
      add :signature, :string

      timestamps()
    end
  end
end
