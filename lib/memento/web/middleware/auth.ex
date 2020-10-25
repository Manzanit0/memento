defmodule Memento.Web.Middleware.Auth do
  @moduledoc """
  Validates if the request is a valid one with the chat ID or not. It's not
  auth per-se since it simply validates if the request body contains a chat
  ID, but it filters out any non-telegram request.
  """

  import Plug.Conn
  require Logger

  def init([]), do: false

  # Telegram inline keyboard callback
  def call(%{body_params: %{"callback_query" => %{"from" => %{"id" => chat_id}}}} = conn, _opts) do
    authenticate_chat_id(conn, chat_id)
  end

  # Telegram standard message
  def call(%{body_params: %{"message" => %{"from" => %{"id" => chat_id}}}} = conn, _opts) do
    authenticate_chat_id(conn, chat_id)
  end

  def call(conn, _opts) do
    halt_unauthorised(conn)
  end

  def halt_unauthorised(conn) do
    Logger.warn("unauthorised request: #{inspect(conn)}")

    conn
    |> send_resp(:unauthorized, "unauthorized")
    |> halt()
  end

  defp authenticate_chat_id(conn, chat_id) do
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
end
