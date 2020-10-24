defmodule Memento.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:chat_id, :string)

      timestamps()
    end

    alter table(:contacts) do
      add(:user_id, references(:users), null: false)
    end

    create unique_index(:users, :chat_id)
  end
end
