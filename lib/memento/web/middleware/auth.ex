defmodule Memento.Web.Middleware.Auth do
  @moduledoc """
  Validates if the request is a valid one with the chat ID or not. It's not
  auth per-se since it simply validates if the request body contains a chat
  ID, but it filters out any non-telegram request.
  """

  import Plug.Conn
  require Logger

  def init([]), do: false

  # Telegram chat_id
  def call(%{body_params: %{"message" => %{"from" => %{"id" => chat_id}}}} = conn, _opts) do
    chat_id
    |> Integer.to_string()
    |> Memento.Users.from_chat_id()
    |> case do
      {:ok, user} ->
        assign(conn, :user, user)

      {:error, err} ->
        Logger.warn("unable to assign user: #{inspect(err)}")
        halt_unauthorised(conn)
    end
  end

  def call(conn, _opts), do: halt_unauthorised(conn)

  def halt_unauthorised(conn) do
    conn
    |> send_resp(:unauthorized, "unauthorized")
    |> halt()
  end
end
