defmodule Authentication.Schema.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field(:device_id, :integer)
    field(:uuid, :string)
    field(:last_resort_pre_key, :string)
    field(:token, :string)
    field(:token_salt, :string)
    field(:gcm, :string)
    field(:apn, :string)

    has_one(:ec_last_resort_signed_pre_key, Authentication.Schema.ECLastResortSignedPreKey)
    has_many(:unsigned_pre_keys, Authentication.Schema.UnsignedPreKeys)

    belongs_to(:user, Authentication.Schema.User)

    timestamps()
  end

  def changeset(device, params \\ %{}) do
    device
    |> cast(params, [:device_id, :uuid, :last_resort_pre_key, :token, :token_salt, :gcm, :apn])
    |> validate_required([
      :device_id,
      :uuid,
      :token,
      :token_salt,
    ])
    |> unique_constraint([:uuid])
  end
end
