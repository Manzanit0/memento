defmodule Memento.Web.TelegramController do
  alias Memento.Contacts
  alias Memento.Users.User

  def handle(%Plug.Conn{body_params: bp, assigns: %{user: user}}) do
    bp
    |> handle_message(user)
    |> to_response(user.chat_id)
    |> Jason.encode!()
  end

  def handle_message(%{"message" => %{"text" => "/contacts:new " <> content}}, %User{} = user) do
    with [person, birthdate] <- String.split(content, ":"),
         date <- parse_birthdate(birthdate),
         {:ok, _contact} <- Contacts.save(%{full_name: person, birthdate: date, user: user}) do
      "Contact saved!"
    else
      _ -> "Sorry... I couldn't save the contact."
    end
  end

  def handle_message(%{"message" => %{"text" => "/contacts:delete " <> name}}, _user) do
    with {:find, contact} when not is_nil(contact) <- {:find, Contacts.find_by_name(name)},
         {:delete, {:ok, _}} <- {:delete, Contacts.delete(contact)} do
      "Contact deleted!"
    else
      {:find, nil} -> "Unable to find contact"
      {:delete, {:err, err}} -> "Unable to delete contact: #{inspect(err)}"
    end
  end

  def handle_message(%{"message" => %{"text" => "/contacts:list"}}, _user) do
    Contacts.all()
    |> Contacts.pretty_print()
    |> Enum.join("\n")
  end

  def handle_message(_body, _user) do
    "Sorry, I don't know how to do that, mate :("
  end

  defp to_response(message, id),
    do: %{method: "sendMessage", chat_id: id, text: message, parse_mode: "markdown"}

  defp parse_birthdate(birthdate) do
    birthdate
    |> String.trim()
    |> Date.from_iso8601!()
  end
end
