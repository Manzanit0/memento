import Config

config :memento, ecto_repos: [Memento.Repo]

import_config "#{Mix.env()}.exs"
