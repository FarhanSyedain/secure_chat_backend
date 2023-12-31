defmodule Core.Schemas.Device do
  use Ecto.Schema

  schema "devices" do
    field(:device_id, :integer)
    field(:uuid, :string)
    field(:last_resort_pre_key, :string)
    field(:token, :string)
    field(:token_salt, :string)
    field(:gcm, :string)
    field(:apn, :string)

    belongs_to(:user, Core.Schemas.User)

    timestamps()
  end
end
