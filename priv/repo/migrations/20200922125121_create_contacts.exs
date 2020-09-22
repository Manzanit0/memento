defmodule Memento.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add(:full_name, :string)
      add(:birthdate, :date)
    end
  end
end
