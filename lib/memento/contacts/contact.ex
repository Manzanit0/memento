defmodule Memento.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field(:full_name, :string)
    field(:birthdate, :date)
  end

  def changeset(contact, attrs \\ %{}) do
    contact
    |> cast(attrs, [:full_name, :birthdate])
    |> unique_constraint(:phone)
  end
end
