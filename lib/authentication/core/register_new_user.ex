defmodule Authentication.Core.RegisterNewUser do
  alias Authentication.Data.Queries.Users
  alias Authentication.Data.Queries.RegistrationSession
  alias Authentication.Data.Queries.Devices

  def register_new_user_session(
        phone_number,
        registration_id,
        auth_token,
        identity_key
      ) do
    case Users.user_exists?(phone_number) do
      true ->
        delete_existing_details(phone_number)

        update_user(
          phone_number,
          registration_id,
          auth_token,
          identity_key
        )

      false ->
        create_user(
          phone_number,
          registration_id,
          auth_token,
          identity_key
        )
    end
  end

  defp update_user(
         phone_number,
         registration_id,
         auth_token,
         identity_key
       ) do
    case Users.update_user(phone_number, registration_id |> String.to_integer(),identity_key) do
      {1, _} ->
        case Devices.create_device(Users.get_user(phone_number), auth_token) do
          {:ok, _} ->
            RegistrationSession.delete(phone_number)
            :ok
          _ ->
            :error
        end

      _ ->
        :error
    end
  end

  defp create_user(
         phone_number,
         registration_id,
         auth_token,
         identity_key
       ) do
    case Users.create_user(phone_number, registration_id |> String.to_integer() ,identity_key ) do
      {:ok, user} ->
        case Devices.create_device(user, auth_token) do
          {:ok, _} ->
            RegistrationSession.delete(phone_number)
            :ok

          _ ->
            :error
        end

      _ ->
        :error
    end
  end

  defp delete_existing_details(phone_number) do
    user = Users.get_user(phone_number)

    Devices.deleteAll(user)
  end
end
