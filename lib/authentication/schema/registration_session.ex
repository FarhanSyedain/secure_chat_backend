defmodule Authentication.Schema.RegistrationSession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registration_sessions" do
    field(:phone_number, :string)
    field(:otp, :string)
    field(:session_creation_time, :naive_datetime)
    field(:otp_retrieval_count, :integer)
    field(:last_otp_retrieval_time, :naive_datetime)
    field(:incorrect_attempt_count, :integer)


  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [
      :phone_number,
      :otp,
      :session_creation_time,
      :otp_retrieval_count,
      :last_otp_retrieval_time,
      :incorrect_attempt_count
    ])
    |> validate_required([
      :phone_number,
      :otp,
      :session_creation_time,
      :otp_retrieval_count,
      :last_otp_retrieval_time,
      :incorrect_attempt_count
    ])
    |> unique_constraint(:phone_number)
  end

end
