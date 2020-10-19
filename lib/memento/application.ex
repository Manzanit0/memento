defmodule Memento.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Memento.Repo,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Memento.Web.Router,
        options: [port: 4001]
      )
    ]

    opts = [strategy: :one_for_one, name: Memento.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
