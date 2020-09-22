defmodule Memento.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Memento.Repo,
      {Memento.Server, [%{}]}
    ]

    opts = [strategy: :one_for_one, name: Memento.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
