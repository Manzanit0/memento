defmodule Memento.Contacts do
  @moduledoc false

  import Ecto.Query
  alias Memento.Repo
  alias Memento.Contacts.Contact

  def save(contact \\ %Contact{}, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.insert_or_update()
  end

  def delete(%Contact{} = c), do: Repo.delete(c)

  def all, do: Repo.all(Contact)

  def pretty_print(contacts) when is_list(contacts), do: Enum.map(contacts, &pretty_print/1)
  def pretty_print(%Contact{} = c), do: "#{c.full_name}: #{c.birthdate}"

  def find_by_name(name) do
    from(c in Contact, where: ilike(c.full_name, ^name), limit: 1)
    |> Repo.one()
  end
end
