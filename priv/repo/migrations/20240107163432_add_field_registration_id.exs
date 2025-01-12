defmodule Core.Repo.Migrations.AddFieldRegistrationId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :registration_id, :integer
    end
  end
end
