defmodule Core.Route.Authentication do
  import Plug.Conn

  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/code" do
    conn |> send_resp(200, "Code sent")
  end
end
