defmodule Core.Repo.Migrations.CreateUnsignedPreKeys do
  use Ecto.Migration

  def change do
    create table(:unsigned_pre_keys) do
      add :key, :string
      add :key_id, :integer
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
