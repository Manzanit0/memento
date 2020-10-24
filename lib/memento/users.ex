defmodule Memento.Users do
  @moduledoc false

  import Ecto.Query
  alias Memento.Repo
  alias Memento.Users.User
  alias Memento.Users.Contact

  def from_chat_id(chat_id) do
    case Repo.get_by(User, chat_id: chat_id) do
      %User{} = user -> {:ok, user}
      nil -> create(%{chat_id: chat_id})
    end
  end

  def create(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def list_contacts(%User{} = user) do
    from(c in Contact)
    |> for_user(user)
    |> Repo.all()
  end

  def add_contact(%User{} = user, attrs) do
    user
    |> Ecto.build_assoc(:contacts, attrs)
    |> Repo.insert_or_update()
  end

  def delete_contact(%User{} = user, contact_name) do
    case find_contact(user, contact_name) do
      nil -> {:error, :no_contact}
      contact -> Repo.delete(contact)
    end
  end

  def find_contact(%User{} = user, contact_name) do
    from(c in Contact, where: ilike(c.full_name, ^contact_name), limit: 1)
    |> for_user(user)
    |> Repo.one()
  end

  defp for_user(q, %User{id: user_id}), do: where(q, [c], c.user_id == ^user_id)
end
