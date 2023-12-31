defmodule Core.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Core.Repo, []},
      {Plug.Cowboy, scheme: :http, plug: Core.EntryPlug, options: [port: 8000]}
    ]

    opts = [strategy: :one_for_one, name: SecureChatBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
