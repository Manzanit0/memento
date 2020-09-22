defmodule Memento.Server do
  use Ace.HTTP.Service, port: 8080, cleartext: true
  use Raxx.SimpleServer

  require Logger
  alias Memento.Web.TelegramController

  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, path: []}, _) do
    Logger.info("Hello World endpoint hit :)")

    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("Hello, World!")
  end

  @impl Raxx.SimpleServer
  def handle_request(%{method: :POST, path: ["api", "telegram"]} = req, _) do
    Logger.info("Telegram Request", body: req.body)

    try do
      response =
        req.body
        |> Jason.decode!()
        |> TelegramController.handle_message()

      response(:ok)
      |> set_header("content-type", "application/json")
      |> set_body(response)
    rescue
      e ->
        Logger.error("Error handling Telegram request: #{e.message}")

        response(:internal_server_error)
        |> set_header("content-type", "text/plain")
        |> set_body("Internal error, dude!")
    end
  end

  @impl Raxx.SimpleServer
  def handle_request(%{method: method, path: path}, _) do
    Logger.info("Not found: #{method} #{path}")

    response(:not_found)
    |> set_header("content-type", "text/plain")
    |> set_body("Not found, love!")
  end
end
