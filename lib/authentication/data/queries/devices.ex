defmodule Authentication.Data.Queries.Devices do
  alias Authentication.Schema.Device
  alias Core.Repo
  import Ecto.Query

  @spec create_device(atom() | %{:id => any(), optional(any()) => any()}, any()) :: any()
  def create_device(user, auth_token,device_id \\ 1) do
    %Device{
      token: auth_token,
      token_salt: Ecto.UUID.generate(),
      device_id: device_id,
      uuid: Ecto.UUID.generate(),
      user_id: user.id
    }
    |> Repo.insert!()
  end

  def deleteAll(user) do
    from(device in Device, where: device.user_id == ^user.id) |> Repo.delete_all()
  end
end
