defmodule RegistrationSession do
  use Ecto.Schema

  schema "registration_sessions" do
    field(:phone_number, :string)
    field(:otp, :string)
    field(:session_creation_time, :naive_datetime)
    field(:otp_retrieval_count, :integer)
    field(:last_otp_retrieval_time, :naive_datetime)
    field(:incorrect_attempt_count, :integer)

    timestamps()
  end
end
