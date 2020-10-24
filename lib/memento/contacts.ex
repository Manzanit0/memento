defmodule Memento.Contacts do
  @moduledoc false

  import Ecto.Query
  alias Memento.Repo
  alias Memento.Contacts.Contact
  alias Memento.Users.User

  def save(contact \\ %Contact{}, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.insert_or_update()
  end

  def delete(%Contact{} = c), do: Repo.delete(c)

  def all(%User{} = user) do
    from(c in Contact)
    |> for_user(user)
    |> Repo.all()
  end

  def pretty_print(contacts) when is_list(contacts), do: Enum.map(contacts, &pretty_print/1)
  def pretty_print(%Contact{} = c), do: "#{c.full_name}: #{c.birthdate}"

  def find_by_name(name, user) do
    from(c in Contact, where: ilike(c.full_name, ^name), limit: 1)
    |> for_user(user)
    |> Repo.one()
  end

  def todays_birthday() do
    from(c in Contact, where: c.birthdate == ^Date.utc_today())
    |> Repo.all()
  end

  defp for_user(q, %User{id: user_id}), do: where(q, [c], c.user_id == ^user_id)
end
