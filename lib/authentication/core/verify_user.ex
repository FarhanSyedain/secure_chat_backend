defmodule Authentication.Core.VerifyUser do
  alias Authentication.Data.Queries.Devices


  def verify_user(uuid,token,device_id) do
    Devices.get_device(device_id,uuid)
    |> case do
      nil ->
        :device_not_found
      device ->
         verify_credentials(device,token)
      end
    end

  defp verify_credentials(device,token) do
   device_token =  device.token
   device_token_salt = device.token_salt

   device_token == :crypto.hash(:sha256, device_token_salt <> token)
end
end
