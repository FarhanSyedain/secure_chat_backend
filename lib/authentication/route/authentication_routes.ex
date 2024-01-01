defmodule Authentication.Route.AuthenticationRoutes do

  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/code" do
    conn |> Authentication.Api.StartRegistration.getCode()
  end
end
