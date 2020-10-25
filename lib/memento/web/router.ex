defmodule Memento.Web.Router do
  use Plug.Router
  use Plug.ErrorHandler
  import Plug.Conn
  require Logger
  alias Memento.Web.Telegram.Controller, as: TelegramController

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["text/*", "application/*"],
    json_decoder: Jason
  )

  plug(Memento.Web.Middleware.DefaultResponseHeaders)
  plug(Memento.Web.Middleware.Auth)

  plug(:dispatch)

  get "/ping" do
    Logger.info("#{inspect(conn.body_params)}")
    send_resp(conn, 200, "pong!")
  end

  post "/api/telegram" do
    msg = TelegramController.handle(conn)
    send_resp(conn, 200, msg)
  end

  match(_, do: send_resp(conn, 404, "Nothing found here!"))

  defp handle_errors(conn, %{reason: reason} = err) do
    Logger.warn("error happened: #{inspect(reason)}", err)
    send_resp(conn, conn.status, "Something went wrong")
  end
end
