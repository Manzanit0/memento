defmodule Memento.BirthdayReminder do
  @moduledoc """
  Sends the users a notification per contact when it's the birthday
  """

  import Ecto.Query
  alias Memento.Repo
  alias Memento.Users.Contact
  alias Memento.Web.Telegram.Notifier

  @date_and_month_match_fragment "extract(month from birthdate) = extract(month from CURRENT_DATE) AND extract(day from birthdate) = extract(day from CURRENT_DATE)"

  def run do
    from(c in Contact,
      where: fragment(@date_and_month_match_fragment),
      preload: [:user]
    )
    |> Repo.all()
    |> IO.inspect()
    |> Enum.map(&notify_birthday/1)
  end

  defp notify_birthday(%Contact{} = contact) do
    Notifier.send_message(
      contact.user,
      "Hey! Just a gentle reminder - today's #{contact.full_name}'s birthday :)"
    )
  end
end
