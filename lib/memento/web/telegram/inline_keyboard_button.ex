defmodule Memento.Web.Telegram.InlineKeyboardButton do
  @moduledoc """
  Represents an inline keyboard attached to a Telegram response.
  """

  @derive Jason.Encoder
  defstruct text: "", callback_data: ""

  def new_button(text) do
    %__MODULE__{text: text, callback_data: text}
  end

  def new_button(text, callback) do
    %__MODULE__{text: text, callback_data: callback}
  end

  def list_contacts_button, do: new_button("🗒 List contacts", "contacts_list")
end
