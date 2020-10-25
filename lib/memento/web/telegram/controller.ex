defmodule Memento.Web.Telegram.Controller do
  require Logger
  alias Memento.Web.Telegram.Response
  alias Memento.Users

  def handle(%Plug.Conn{body_params: bp, assigns: %{user: user}}) do
    try do
      handle_message(bp, user)
    rescue
      err ->
        Logger.warn(err.message)
        Response.new("Houston, we have an error: #{inspect(err)}", user.chat_id)
    end
    |> Jason.encode!()
  end

  def handle_message(%{"message" => %{"text" => "/contacts_new " <> content}}, user) do
    with [person, birthdate] <- String.split(content, ":"),
         date <- parse_birthdate(birthdate),
         {:ok, _contact} <- Users.add_contact(user, %{full_name: person, birthdate: date}) do
      """
      Brilliant, I saved the contact!
      Do you need anything else?
      """
      |> Response.new(user.chat_id)
      |> Response.with_list_contacts_keyboard()
    else
      _ -> Response.new("Sorry... I couldn't save the contact.", user.chat_id)
    end
  end

  def handle_message(%{"message" => %{"text" => "/contacts_delete " <> name}}, user) do
    case Users.delete_contact(user, name) do
      {:ok, _} -> "Amazing, contact deleted! Anything else?"
      {:error, :no_contact} -> "Are you sure we're keeping tabs on that bloke?"
      {:error, err} -> "Ouch. I couldn't delete them: #{inspect(err)}"
    end
    |> Response.new(user.chat_id)
    |> Response.with_list_contacts_keyboard()
  end

  def handle_message(%{"message" => %{"text" => "/contacts_list"}}, user) do
    user
    |> Users.list_contacts()
    |> list_contacts_response(user.chat_id)
  end

  def handle_message(
        %{
          "callback_query" => %{
            "message" => %{
              "reply_markup" => %{
                "inline_keyboard" => [[%{"callback_data" => "contacts_list"}]]
              }
            }
          }
        },
        user
      ) do
    user
    |> Users.list_contacts()
    |> list_contacts_response(user.chat_id)
  end

  def handle_message(_body, user) do
    Response.new("Sorry, I don't know how to do that, mate :(", user.chat_id)
  end

  ## Private.

  defp list_contacts_response(contacts, chat_id) do
    rendered = contacts |> pretty_print() |> Enum.join("\n")

    """
    Rad, these are your contacts:

    #{rendered}

    Can I do anything else for you?
    """
    |> Response.new(chat_id)
  end

  defp parse_birthdate(birthdate) do
    birthdate
    |> String.trim()
    |> Date.from_iso8601!()
  end

  defp pretty_print(contacts) when is_list(contacts), do: Enum.map(contacts, &pretty_print/1)
  defp pretty_print(c), do: "#{c.full_name}: #{c.birthdate}"
end
