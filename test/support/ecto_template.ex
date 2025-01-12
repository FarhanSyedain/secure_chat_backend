defmodule ChatBackendTest.Support.EctoTemplate do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Core.Repo

      import Ecto
      import Ecto.Query
      import ChatBackendTest.Support.EctoTemplate

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Core.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Core.Repo, {:shared, self()})
    end

    :ok
  end
end
