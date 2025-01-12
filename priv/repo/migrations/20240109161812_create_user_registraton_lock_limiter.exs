defmodule Core.Repo.Migrations.CreateUserRegistratonLockLimiter do
  use Ecto.Migration

  def change do
    create table(:user_registration_lock_limiter) do
      add :incorrect_attempt_count, :integer, null: false
      add :last_attempt_time, :naive_datetime, null: false

      add :user_id , references(:users, on_delete: :delete_all), null: false
    end
  end
end
