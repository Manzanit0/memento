defmodule Memento.Users do
  @moduledoc false

  alias Memento.Repo
  alias Memento.Users.User

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
end
