defmodule Core.Repo.Migrations.SignedPreKeyAddFieldKeyId do
  use Ecto.Migration

  def change do
    alter table(:ec_signed_pre_keys) do
      add :key_id, :integer
    end
  end
end
