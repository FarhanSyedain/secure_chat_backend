defmodule Core.Repo.Migrations.CreateEcSignedPreKey do
  use Ecto.Migration

  def change do
    create table(:ec_signed_pre_keys) do
      add :key, :string
      add :signature, :string

      timestamps()
    end
  end
end
