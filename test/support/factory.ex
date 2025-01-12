defmodule ChatBackendTest.Support.Factory do
  # alias Authentication.Schema.User

  alias Core.Repo

  require Logger

  def create(_, _) do
  #   Logger.error("Should print on console")

  #   user_data =
  #     Keyword.merge(
  #       [
  #         phone_number: Faker.Phone.PtBr.phone(),
  #         uuid: Faker.UUID.v4(),
  #         last_seen: NaiveDateTime.utc_now(),
  #         registration_id: Faker.UUID.v4()
  #       ],
  #       attrs
  #     )

  #   try do
  #     User |> struct(user_data) |> Repo.insert(returning: true)
  #   rescue
  #     e ->
  #       Logger.error("Error: #{inspect(e)}")
  #   end
  # end
    IO.puts("Works till herdddde")
end
end
