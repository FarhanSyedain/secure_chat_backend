defmodule Authentication.Schema.ECLastResortSignedPreKey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "last_resort_ec_signed_pre_keys" do
    field(:key, :string)
    field(:signature, :string)

    belongs_to(:device, Authentication.Schema.Device)

  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [
      :key,
      :signature
    ])
    |> validate_required([
      :key,
      :signature
    ])
  end
end
