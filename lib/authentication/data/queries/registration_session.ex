defmodule Authentication.Data.Queries.RegistrationSession do
  import Ecto.Query
  alias Authentication.Schema.RegistrationSession
  alias Core.Repo

  @spec create(any()) :: any()
  def create(phone_number) do
    otp = generate_otp()

    session_id = Ecto.UUID.generate()

    %RegistrationSession{
      phone_number: phone_number,
      otp: otp,
      session_creation_time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      otp_retrieval_count: 0,
      last_otp_retrieval_time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      incorrect_attempt_count: 0,
      session_id: session_id,
      is_verified: false
    }
    |> Repo.insert!()

    {:ok, otp, session_id}
  end

  def get(phone_number) do

    from(rs in RegistrationSession, where: rs.phone_number == ^phone_number)
    |> Repo.one()
  end

  def get_by_session_id(session_id) do
    from(rs in RegistrationSession, where: rs.session_id == ^session_id)
    |> Repo.one()
  end

  def session_id_exists?(session_id) do
    from(rs in RegistrationSession, where: rs.session_id == ^session_id and rs.is_verified == false)
    |> Repo.one()
    |> is_nil()
    |> Kernel.not()
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
