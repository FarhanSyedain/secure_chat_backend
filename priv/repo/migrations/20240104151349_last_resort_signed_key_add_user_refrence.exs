defmodule Core.Repo.Migrations.LastResortSignedKeyAddUserRefrence do
  use Ecto.Migration

  def change do
    alter table(:last_resort_ec_signed_pre_keys) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
