defmodule Core.EntryPlug do
  import Plug.Conn

  alias Authentication.Route.AuthenticationRoutes

  @type json :: String.t() | number | boolean | nil | [json] | %{String.t() => json}

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  options _ do
    send_resp(conn, 200, "")
  end

  forward("/auth", to: AuthenticationRoutes)

  get _ do
    send_resp(conn, 404, "not found")
  end

  post _ do
    send_resp(conn, 404, "not found")
  end
end
