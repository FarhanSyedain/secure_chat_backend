defmodule Core.Repo.Migrations.AddTimestampsToDevices do
  use Ecto.Migration

  def change do
    alter table(:devices) do
      timestamps()
    end
  end
end
