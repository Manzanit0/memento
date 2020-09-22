defmodule Memento.Web.TelegramController do
  alias Memento.Contacts

  def handle_message(%{"message" => %{"text" => "/contacts:new " <> content}} = body) do
    chat_id = get_chat_id(body)

    with [person, birthdate] <- String.split(content, ":"),
         date <- parse_birthdate(birthdate),
         {:ok, _contact} <- Contacts.save(%{full_name: person, birthdate: date}) do
      "Contact saved!"
    else
      _ -> "Sorry... couldn't save the contact."
    end
    |> to_response(chat_id)
    |> Jason.encode!()
  end

  def handle_message(%{"message" => %{"text" => "/contacts:delete " <> name}} = body) do
    chat_id = get_chat_id(body)

    with {:find, contact} when not is_nil(contact) <- {:find, Contacts.find_by_name(name)},
         {:delete, {:ok, _}} <- {:delete, Contacts.delete(contact)} do
      "Contact deleted!"
    else
      {:find, nil} -> "Unable to find contact"
      {:delete, {:err, err}} -> "Unable to delete contact #{inspect(err)}"
    end
    |> to_response(chat_id)
    |> Jason.encode!()
  end

  def handle_message(%{"message" => %{"text" => "/contacts:list"}} = body) do
    chat_id = get_chat_id(body)

    Contacts.all()
    |> Contacts.pretty_print()
    |> Enum.join("\n")
    |> to_response(chat_id)
    |> Jason.encode!()
  end

  def handle_message(%{"message" => %{"from" => %{"id" => id}}}) do
    "Sorry, I don't know how to do that, mate :("
    |> to_response(id)
    |> Jason.encode!()
  end

  def handle_message(_body),
    do: "WTF, this isn't a telegram message. Fuck off."

  defp to_response(message, id),
    do: %{method: "sendMessage", chat_id: id, text: message, parse_mode: "markdown"}

  defp get_chat_id(body), do: get_in(body, ["message", "from", "id"])

  defp parse_birthdate(birthdate) do
    birthdate
    |> String.trim()
    |> Date.from_iso8601!()
  end
end
