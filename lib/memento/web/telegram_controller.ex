defmodule Memento.Web.TelegramController do
  alias Memento.Users.Contact
  alias Memento.Users

  def handle(%Plug.Conn{body_params: bp, assigns: %{user: user}}) do
    try do
      handle_message(bp, user)
    rescue
      err -> "Houston, we have an error: #{inspect(err)}"
    end
    |> to_response(user.chat_id)
    |> Jason.encode!()
  end

  def handle_message(%{"message" => %{"text" => "/contacts:new " <> content}}, user) do
    with [person, birthdate] <- String.split(content, ":"),
         date <- parse_birthdate(birthdate),
         {:ok, _contact} <- Users.add_contact(user, %{full_name: person, birthdate: date}) do
      "Contact saved!"
    else
      _ -> "Sorry... I couldn't save the contact."
    end
  end

  def handle_message(%{"message" => %{"text" => "/contacts:delete " <> name}}, user) do
    case Users.delete_contact(user, name) do
      {:ok, _} -> "Contact deleted!"
      {:error, :no_contact} -> "Contact not found"
      {:error, err} -> "Unable to delete contact: #{inspect(err)}"
    end
  end

  def handle_message(%{"message" => %{"text" => "/contacts:list"}}, user) do
    user
    |> Users.list_contacts()
    |> pretty_print()
    |> Enum.join("\n")
  end

  def handle_message(_body, _user) do
    "Sorry, I don't know how to do that, mate :("
  end

  defp to_response(message, id),
    do: %{
      method: "sendMessage",
      chat_id: String.to_integer(id),
      text: message,
      parse_mode: "markdown"
    }

  defp parse_birthdate(birthdate) do
    birthdate
    |> String.trim()
    |> Date.from_iso8601!()
  end

  defp pretty_print(contacts) when is_list(contacts), do: Enum.map(contacts, &pretty_print/1)
  defp pretty_print(%Contact{} = c), do: "#{c.full_name}: #{c.birthdate}"
end
