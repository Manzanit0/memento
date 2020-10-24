defmodule Memento.Users.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Memento.Repo

  schema "contacts" do
    field(:full_name, :string)
    field(:birthdate, :date)
    belongs_to(:user, Memento.Users.User, on_replace: :raise)

    timestamps()
  end

  def changeset(contact, attrs \\ %{}) do
    contact
    |> Repo.preload(:user)
    |> cast(attrs, [:full_name, :birthdate])
    |> put_assoc(:user, attrs[:user])
    |> validate_required([:user, :full_name, :birthdate])
  end
end
