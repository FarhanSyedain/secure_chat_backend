defmodule Core.Repo.Migrations.AddFieldsToRegistrationSession do
  use Ecto.Migration

  def change do
    alter table("registration_sessions") do
      add :session_id, :string
      add :is_verified, :boolean, default: false
    end
  end
end
