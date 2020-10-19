defmodule Memento.Web.Middleware.Auth do
  @moduledoc """
  Validates if the request is a valid one with the chat ID or not.
  """
  require Logger

  def init([]), do: false

  def call(%Plug.Conn{body_params: bp} = conn, _opts) do
    chat_id = get_chat_id(bp)
    append_auth_header(conn, chat_id)
  end

  defp get_chat_id(body), do: get_in(body, ["message", "from", "id"])

  defp append_auth_header(%{req_headers: headers} = conn, chat_id),
    do: %{conn | req_headers: [headers | {"x-memento-chat-id", chat_id}]}
end
