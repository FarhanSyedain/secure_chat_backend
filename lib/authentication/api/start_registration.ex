defmodule Authentication.Api.StartRegistration do
  import Plug.Conn
  alias Authentication.Data.Queries.RegistrationSession

  @spec getCode(Plug.Conn.t()) :: Plug.Conn.t()
  def getCode(conn) do
    with %{"phone_number" => phone_number} <- conn.query_params do
      case handle_otp_request(phone_number) do
        {:ok, session_id} ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(
            200,
            Jason.encode!(%{
              code: "otp_sent",
              data: %{session_id: session_id},
              message: "OTP sent successfully"
            })
          )

        :retry_later ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(
            200,
            Jason.encode!(%{code: "retry_later", message: "Please try again later"})
          )

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

  defp handle_otp_request(phone_number) do
    with nil <- RegistrationSession.get(phone_number) do
      {:ok, otp, session_id} = RegistrationSession.create(phone_number)
      send_code(phone_number, otp, session_id)
    else
      session ->
        current_time = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        session_creation_time = NaiveDateTime.truncate(session.session_creation_time, :second)

        session_otp_retrieval_time =
          NaiveDateTime.truncate(session.last_otp_retrieval_time, :second)

        session_otp_retrieval_count = session.otp_retrieval_count

        if current_time < NaiveDateTime.add(session_otp_retrieval_time, 1, :minute) and
             session_otp_retrieval_count >= 1 do
          :retry_later
        else
          if session_otp_retrieval_count >= 4 and
               NaiveDateTime.add(session_otp_retrieval_time, 1, :day) < session_creation_time do
            :too_many_requests
          else
            {:ok, otp} =
              RegistrationSession.update_otp(phone_number, session_otp_retrieval_count + 1)

            send_code(phone_number, otp, session.session_id)
          end
        end
    end
  end

  defp send_code(_phone_number, otp, session_id) do
    IO.puts("The current otp is #{otp}")
    {:ok, session_id}
  end
end
