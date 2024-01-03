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

  @spec otp_expired?(any()) :: boolean()
  def otp_expired?(session_id) do
    registration_session = get_by_session_id(session_id)

    last_otp_retrieval_time = registration_session.last_otp_retrieval_time
    NaiveDateTime.diff(NaiveDateTime.utc_now(), last_otp_retrieval_time, :second) > 1080
  end

  @spec validate_otp(any(), any()) :: :ok | :otp_mismatch
  def validate_otp(session_id, otp) do
    registration_session = get_by_session_id(session_id)

    case otp == registration_session.otp do
      true ->
        validate_session(session_id)
        :ok

      false ->
        increase_incorrect_attempt_count(session_id,registration_session.incorrect_attempt_count)
        :otp_mismatch
    end
  end
  defp increase_incorrect_attempt_count(session_id,previous_count) do
    from(rs in RegistrationSession, where: rs.session_id == ^session_id)
    |> Repo.update_all(
      set: [ incorrect_attempt_count: previous_count + 1]
    )
  end

  @spec validate_session(any()) :: any()
  defp validate_session(session_id) do
    from(rs in RegistrationSession, where: rs.session_id == ^session_id)
    |> Repo.update_all(set: [is_verified: true])
  end

  @spec has_too_many_incorrect_attempt_count?(any()) :: boolean()
  def has_too_many_incorrect_attempt_count?(session_id) do
    registration_session = get_by_session_id(session_id)

    incorrect_attempt_count = registration_session.incorrect_attempt_count

    incorrect_attempt_count > 5
  end

  defp generate_otp() do
    :crypto.strong_rand_bytes(6)
    |> Base.encode16()
    |> String.replace(~r/[^0-9]/, "")
    |> String.slice(0..(6 - 1))
  end
end
