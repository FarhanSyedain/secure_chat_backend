defmodule Core.Repo.Migrations.AddFieldLastSeen do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_seen, :naive_datetime
    end
  end
end
