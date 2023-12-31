defmodule Core.Schemas.User do
  use Ecto.Schema

  schema "users" do
    field(:phone_number, :string)
    field(:uuid, :string)
    field(:registration_salt, :string)
    field(:registration_lock, :string)
    field(:identity_key, :string)

    has_many(:device, Core.Schemas.Device)

    timestamps()
  end
end
