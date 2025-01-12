defmodule Authentication.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:phone_number, :string)
    field(:uuid, :string)
    field(:registration_salt, :string)
    field(:registration_lock, :string)
    field(:identity_key, :string)
    field(:last_seen, :naive_datetime)
    field(:registration_id, :integer)

    has_many(:device, Authentication.Schema.Device)
    has_one(:user_registration_lock_limiter, Authentication.Schema.UserRegistrationLockLimiter)
    
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:phone_number, :uuid, :registration_salt, :registration_lock, :identity_key])
    |> validate_required([
      :phone_number,
      :uuid,
      :identity_key
    ])
    |> unique_constraint([:phone_number, :uuid])
  end
end
