defmodule Authentication.Data.Queries.Users do
  import Ecto.Query
  alias Authentication.Schema.User
  alias Core.Repo

  def user_exists?(phone_number) do
    from(u in User, where: u.phone_number == ^phone_number)
    |> Repo.one()
    |> is_nil()
    |> Kernel.not()
  end

  def last_seen(phone_number) do
    from(u in User, where: u.phone_number == ^phone_number)
    |> Repo.one()
    |> Map.get(:last_seen)
  end

  def has_pin_verifications?(phone_number) do
    from(u in User, where: u.phone_number == ^phone_number)
    |> Repo.one()
    |> has_pin?()
  end

  defp has_pin?(user) do
    case user.registration_lock do
      nil -> false
      _ -> true
    end
  end

  def delete(phone_number) do
    from(u in User, where: u.phone_number == ^phone_number)
    |> Repo.delete_all()

    :ok
  end

  def create_user(phone_number, registration_id) do

    %User{
      phone_number: phone_number,
      uuid: Ecto.UUID.generate(),
      registration_id: registration_id,
      last_seen: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }
    |> Repo.insert!()
  end


  def remove_details(phone_number) do
   from(u in User, where: u.phone_number == ^phone_number) |> Repo.update_all(
     set: [
       registration_id: nil,
       identity_key: nil
     ]
   )
  end

  def get_user(phone_number) do
    from(u in User, where: u.phone_number == ^phone_number)
    |> Repo.one()
  end


  def update_user(phone_number, registration_id) do

    from(u in User, where: u.phone_number == ^phone_number)
    |> Repo.update_all(
      set: [
        registration_id: registration_id,
        last_seen: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
      ]
    )

  end
end
