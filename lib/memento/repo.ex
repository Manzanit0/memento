defmodule Memento.Repo do
  use Ecto.Repo,
    otp_app: :memento,
    adapter: Ecto.Adapters.Postgres
end
