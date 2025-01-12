defmodule Authentication.Schema.UserRegistrationLockLimiter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_registration_lock_limiter" do
    field(:incorrect_attempt_count, :integer)
    field(:last_attempt_time, :naive_datetime)

    belongs_to(:user, Authentication.Schema.User)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [
      :user_id,
      :incorrect_attempt_count,
      :last_attempt_time
    ])
    |> validate_required([
      :user_id,
      :incorrect_attempt_count,
      :last_attempt_time
    ])
  end
end
