defmodule Authentication.Data.Queries.RegistrationSession do
  import Ecto.Query
  alias Authentication.Schema.RegistrationSession
  alias Core.Repo

  @spec create(any()) :: any()
  def create(phone_number) do
    otp = generate_otp()

    %RegistrationSession{
      phone_number: phone_number,
      otp: otp,
      session_creation_time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      otp_retrieval_count: 0,
      last_otp_retrieval_time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      incorrect_attempt_count: 0
    }
    |> Repo.insert!()

    {:ok, otp}
  end

  def get(phone_number) do

    from(rs in RegistrationSession, where: rs.phone_number == ^phone_number)
    |> Repo.one()
  end

  def delete(phone_number) do
    from(rs in RegistrationSession, where: rs.phone_number == ^phone_number)
    |> Repo.delete_all()

    :ok
  end

  def update_otp(phone_number, otp_retrieval_count) do
    otp = generate_otp()

    from(rs in RegistrationSession, where: rs.phone_number == ^phone_number)
    |> Repo.update_all(
      set: [
        otp: otp,
        otp_retrieval_count: otp_retrieval_count,
        last_otp_retrieval_time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
      ]
    )

    {:ok, otp}
  end

  defp generate_otp() do
    :crypto.strong_rand_bytes(6)
    |> Base.encode16()
    |> String.slice(0..5)
  end
end
