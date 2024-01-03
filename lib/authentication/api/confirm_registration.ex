defmodule Authentication.Api.ConfirmRegistration do
  import Plug.Conn

  alias Authentication.Data.Queries.RegistrationSession

  @spec confirm_code(Plug.Conn.t()) :: Plug.Conn.t()
  def confirm_code(conn) do
    IO.inspect(conn.params)

    with %{"session_id" => session_id, "otp" => otp} <- conn.params do
      case handle_otp_confirmation(session_id, otp) do
        :ok ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{code: "otp_confirmed", message: "OTP confirmed"}))

        :otp_expired ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(401, Jason.encode!(%{code: "otp_expired", message: "OTP expired"}))

        :session_invalid ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(
            400,
            Jason.encode!(%{code: "session_invalid", message: "Session invalid"})
          )

        :otp_mismatch ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(401, Jason.encode!(%{code: "otp_mismatch", message: "OTP mismatch"}))

        :too_many_requests ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(
            429,
            Jason.encode!(%{
              code: "too_many_requests",
              message: "Too many requests. Try again later"
            })
          )
      end
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{code: "missing_fields", message: "Missing fields"}))
    end
  end

  defp handle_otp_confirmation(session_id, otp) do
    cond do
      RegistrationSession.session_id_exists?(session_id) |> Kernel.not() ->
        :session_invalid

      RegistrationSession.otp_expired?(session_id) ->
        :otp_expired

      RegistrationSession.has_too_many_incorrect_attempt_count?(session_id) ->
        :too_many_requests

      true ->
        RegistrationSession.validate_otp(session_id, otp)
    end
  end
end
