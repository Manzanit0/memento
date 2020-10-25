defmodule Memento.Web.Telegram.Response do
  @moduledoc """
  Represents a Telegram response. It may or may not have an inline keyboard.
  """

  import Memento.Web.Telegram.InlineKeyboardButton

  @derive Jason.Encoder
  defstruct method: "sendMessage",
            chat_id: -1,
            text: "",
            parse_mode: "markdown",
            reply_markup: %{}

  def new(text, chat_id) do
    %__MODULE__{text: text, chat_id: chat_id}
  end

  def with_list_contacts_keyboard(%__MODULE__{} = response) do
    %{response | reply_markup: %{inline_keyboard: [[list_contacts_button()]]}}
  end
end
