defmodule Core.Repo.Migrations.SignedKeyAddUserRefrence do
  use Ecto.Migration

  def change do
    alter table(:ec_signed_pre_keys) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
