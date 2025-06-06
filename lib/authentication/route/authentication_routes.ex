defmodule Authentication.Route.AuthenticationRoutes do
  alias Authentication.Api.StartRegistration
  alias Authentication.Api.ConfirmRegistration
  alias Authentication.Api.UserExists
  alias Authentication.Api.Register

  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json,:multipart],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/session/code" do
    conn |> StartRegistration.getCode()
  end

  post "/session/post" do
    conn |> ConfirmRegistration.confirm_code()
  end

  post "user/existence" do
    conn |> UserExists.user_exists()
  end
  post "user/create" do
    conn |> Register.register()
  end
end
