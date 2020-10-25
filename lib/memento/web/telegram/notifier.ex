defmodule Memento.Web.Telegram.Notifier do
  alias Memento.Users.User
  alias Memento.Web.Telegram.Response

  def send_message(%User{chat_id: chat_id}, message) do
    body =
      message
      |> Response.new(chat_id)
      |> Jason.encode!()

    send_message_endpoint()
    |> HTTPoison.post(body, "Content-Type": "Application/json")
  end

  defp send_message_endpoint do
    token = Application.get_env(:memento, :telegram_token)
    "https://api.telegram.org/bot#{token}/sendMessage"
  end
end
