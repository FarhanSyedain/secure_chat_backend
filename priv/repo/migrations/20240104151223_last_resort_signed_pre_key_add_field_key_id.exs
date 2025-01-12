defmodule Core.Repo.Migrations.LastResortSignedPreKeyAddFieldKeyId do
  use Ecto.Migration

  def change do
    alter table(:last_resort_ec_signed_pre_keys) do
      add :key_id, :integer
    end
  end
end
