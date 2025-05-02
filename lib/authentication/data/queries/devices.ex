defmodule Authentication.Data.Queries.Devices do
  alias Authentication.Schema.Device
  alias Core.Repo
  import Ecto.Query

  @spec create_device(atom() | %{:id => any(), optional(any()) => any()}, any()) :: any()
  def create_device(user, auth_token,device_id \\ 1) do
    
    token_salt = Ecto.UUID.generate()
    token = :crypto.hash(:sha256, token_salt <> auth_token)

    %Device{
      token: token,
      token_salt: token,
      device_id: device_id,
      uuid: Ecto.UUID.generate(),
      user_id: user.id
    }
    |> Repo.insert!()
  end

  def deleteAll(user) do
    from(device in Device, where: device.user_id == ^user.id) |> Repo.delete_all()
  end

  def get_device(device_id,uuid) do
    from(d in Device,
      where: d.device_id == ^device_id and d.uuid == ^uuid,
      select: d
    )
    |> Repo.one()
  end
end
