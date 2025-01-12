ExUnit.start()


Ecto.Adapters.SQL.Sandbox.mode(Core.Repo, :manual)

Faker.start()


defmodule ChatBackendTest do
  use ExUnit.Case, async: true
  alias ChatBackendTest.Support.Factory

  use ChatBackendTest.Support.EctoTemplate


  require Logger
  alias Core.Schema.User


  test "create user" do
    IO.puts("Should Print thisdd too")

    _ = Factory.create(User, %{})

    IO.puts("Should Print this too")
#
  end



end
