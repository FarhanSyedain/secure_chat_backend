defmodule Authentication.Core.UserRegistrationLockLimiter do
  alias Authentication.Schema.UserRegistrationLockLimiter
  alias Core.Repo
  import Ecto.Query

  def create_user_registration_lock_limiter(user, incorrect_attempt_count \\ 1) do
    %UserRegistrationLockLimiter{
      user_id: user.id,
      incorrect_attempt_count: incorrect_attempt_count,
      last_attempt_time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }
    |> Repo.insert!()
  end

  def register_incorrect_attempt(user) do
    from(user_registration_lock_limiter in UserRegistrationLockLimiter,
      where: user_registration_lock_limiter.user_id == ^user.id
    )
    |> Repo.update_all(
      inc: [incorrect_attempt_count: 1],
      set: [
        last_attempt_time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
      ]
    )
  end

  def get(user) do
    from(user_registration_lock_limiter in UserRegistrationLockLimiter,
      where: user_registration_lock_limiter.user_id == ^user.id
    )
    |> Repo.one()
  end

  def delete(user) do
    from(user_registration_lock_limiter in UserRegistrationLockLimiter,
      where: user_registration_lock_limiter.user_id == ^user.id
    )
    |> Repo.delete_all()
  end
end
