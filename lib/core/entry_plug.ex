defmodule Broth do
  import Plug.Conn

  alias Core.Route.Authentication

  @type json :: String.t() | number | boolean | nil | [json] | %{String.t() => json}

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  options _ do
    send_resp(conn, 200, "")
  end

  forward("/auth", to: Authentication)

  get _ do
    send_resp(conn, 404, "not found")
  end

  post _ do
    send_resp(conn, 404, "not found")
  end
end
