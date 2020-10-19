defmodule Memento.Web.Router do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  plug(Plug.Logger)
  plug(:match)

  plug(Memento.Web.Middleware.DefaultResponseHeaders)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["text/*", "application/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/ping" do
    Logger.info("#{inspect(conn.body_params)}")
    send_resp(conn, 200, "pong!")
  end

  post "/telegram" do
    msg = Memento.Web.TelegramController.handle(conn)
    send_resp(conn, 200, msg)
  end

  match(_, do: send_resp(conn, 404, "Nothing found here!"))

  defp handle_errors(conn, %{reason: reason} = err) do
    Logger.warn("error happened: #{reason}", err)
    send_resp(conn, conn.status, "Something went wrong")
  end
end
