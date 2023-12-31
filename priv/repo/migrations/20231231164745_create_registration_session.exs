defmodule Core.Repo.Migrations.CreateRegistrationSession do
  use Ecto.Migration

  def change do
    create table(:registration_sessions) do
      add :phone_number, :string
      add :otp, :string
      add :session_creation_time, :naive_datetime
      add :otp_retrieval_count, :integer
      add :last_otp_retrieval_time, :naive_datetime
      add :incorrect_attempt_count, :integer
    end
  end
end
