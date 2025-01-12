defmodule Authentication.Schema.UnsignedPreKeys do
  use Ecto.Schema
  import Ecto.Changeset

  schema "unsigned_pre_keys" do
    field(:key, :string)
    field(:key_id, :integer)

    belongs_to(:device, Authentication.Schema.Device)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [
      :key,
      :key_id
    ])
    |> validate_required([
      :key,
      :key_id
    ])
  end
end
