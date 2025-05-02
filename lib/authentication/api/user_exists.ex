defmodule Authentication.Api.UserExists do
  import Plug.Conn
  alias Authentication.Data.Queries.Users

  @spec user_exists(Plug.Conn.t()) :: Plug.Conn.t()
  def user_exists(conn) do
    with %{"phone_number" => phone_number} <- conn.params do
      case Users.user_exists?(phone_number) do
        true ->
          user_locked? = is_user_locked?(phone_number)
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{code: "user_exists", message: "User exists",data: %{is_user_locked: user_locked?}}))

        false ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(404, Jason.encode!(%{code: "user_not_found", message: "User not found"}))
      end
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{code: "missing_fields", message: "Missing fields"}))
    end
  end

  
  defp is_user_locked?(phone_number) do
    NaiveDateTime.compare(
      NaiveDateTime.truncate(
        NaiveDateTime.add(Users.get_user(phone_number),7,:day), :second
    ),

  NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    ) == :gt

  end
end
