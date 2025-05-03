defmodule Authentication.Api.Register do
  import Plug.Conn
  alias Authentication.Schema.RegistrationSession
  alias Authentication.Data.Queries.RegistrationSession
  alias Authentication.Data.Queries.Users
  alias Authentication.Core.RegisterNewUser
  alias Authentication.Core.RegisterWithPin

  def register(conn) do
    case conn.body_params do
      %{
        "session_id" => session_id,
        "registration_id" => registration_id,
        "phone_number" => phone_number,
        "auth_token" => auth_token,
        "identity_key" => identity_key,
      } ->
        cond do
          :error == RegistrationSession.verify_registration_session(session_id, phone_number) ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(
              400,
              Jason.encode!(%{code: "invalid_session", message: "Invalid Session"})
            )

          :ok ->
            has_pin_verification = Users.has_pin_verifications?(phone_number)
            pin = conn.body_params["pin"]

            case has_pin_verification do
              false -> register(conn, phone_number, registration_id, auth_token,identity_key)
              true -> verify_pin(conn, phone_number, registration_id, pin, auth_token,identity_key)
            end
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{code: "missing_fields", message: "Missing fields"}))
    end
  end

  defp verify_pin(conn, phone_number, registration_id, pin, auth_token,identity_key) do
    case RegisterWithPin.verify_and_register(
           phone_number,
           registration_id,
           pin,
           auth_token,
           identity_key
         ) do
      :blocked ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          429,
          Jason.encode!(%{
            code: "account_registration_booked",
            message: "Too many requests. Try again later"
          })
        )

      :incorrect_pin ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{
            code: "incorrect_pin",
            message: "Incorrect pin"
          })
        )

      :ok ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{code: "ok", message: "ok"}))

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{code: "error", message: "error"}))
    end
  end

  defp register(conn, phone_number, registration_id, auth_token,identity_key) do
    case RegisterNewUser.register_new_user(
           phone_number,
           registration_id,
           auth_token,
           identity_key
         ) do
      :ok ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{code: "ok", message: "ok"}))

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{code: "error", message: "error"}))
    end
  end
end
