defmodule Core.Repo.Migrations.DeleteSignedPrekeys do
  use Ecto.Migration

  def change do
    drop table(:ec_signed_pre_keys)
  end
end
