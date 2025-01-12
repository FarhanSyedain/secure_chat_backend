defmodule Authentication.Core.RegisterWithPin do
  alias Authentication.Data.Queries.Users
  alias Authentication.Core.RegisterNewUser
  alias Authentication.Core.UserRegistrationLockLimiter

  @seven_days 60 * 60 * 24 * 7

  def verify_and_register(phone_number, registration_id, pin, auth_token) do
    user = Users.get_user(phone_number)

    case verify_registration_rate_limit(user) do
      :blocked ->
        :blocked

      {:ok, incorrect_attempt_count} ->
        process_registration(
          user,
          incorrect_attempt_count,
          phone_number,
          registration_id,
          pin,
          auth_token
        )
    end
  end

  defp process_registration(
         user,
         incorrect_attempt_count,
         phone_number,
         registration_id,
         pin,
         auth_token
       ) do
    time_since_user_activity =
      NaiveDateTime.diff(NaiveDateTime.utc_now(), user.last_seen, :second)

    if time_since_user_activity > @seven_days do
      RegisterNewUser.register_new_user(phone_number, registration_id, auth_token)
    else
      process_pin_verification(
        user,
        incorrect_attempt_count,
        pin,
        phone_number,
        registration_id,
        auth_token
      )
    end
  end

  defp process_pin_verification(
         user,
         incorrect_attempt_count,
         pin,
         phone_number,
         registration_id,
         auth_token
       ) do
    if incorrect_attempt_count >= 3 do
      :blocked
    else
      hashed_user_pin = user.registration_lock
      user_pin_salt = user.registration_lock_salt
      hashed_input_pin = :crypto.hash(:sha256, user_pin_salt <> pin)

      if hashed_input_pin == hashed_user_pin do
        RegisterNewUser.register_new_user(phone_number, registration_id, auth_token)
      else
        process_incorrect_pin(user)
      end
    end
  end

  defp process_incorrect_pin(user) do
    case UserRegistrationLockLimiter.get(user) do
      nil ->
        UserRegistrationLockLimiter.create_user_registration_lock_limiter(user)
        :incorrect_pin

      lock_limiter ->
        UserRegistrationLockLimiter.register_incorrect_attempt(user)
        if lock_limiter.incorrect_attempt_count >= 3, do: :blocked, else: :incorrect_pin
    end
  end

  defp verify_registration_rate_limit(user) do
    lock_limiter = UserRegistrationLockLimiter.get(user)

    if lock_limiter && lock_limiter.incorrect_attempt_count >= 3 do
      verify_attempt_time(lock_limiter)
    else
      {:ok, (lock_limiter && lock_limiter.incorrect_attempt_count) || 0}
    end
  end

  defp verify_attempt_time(lock_limiter) do
    time_since_last_attempt =
      NaiveDateTime.diff(NaiveDateTime.utc_now(), lock_limiter.last_attempt_time, :second)

    if time_since_last_attempt > @seven_days do
      {:ok, lock_limiter.incorrect_attempt_count}
    else
      :blocked
    end
  end
end
