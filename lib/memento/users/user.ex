defmodule Memento.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:chat_id, :string)
    has_many(:contacts, Memento.Users.Contact)

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:chat_id])
    |> unique_constraint(:chat_id)
  end
end
