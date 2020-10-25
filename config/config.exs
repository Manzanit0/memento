import Config

config :memento, ecto_repos: [Memento.Repo]
config :memento, :telegram_token, System.get_env("TELEGRAM_BOT_TOKEN") || "N/A"

config :memento, Memento.Scheduler,
  jobs: [
    # Remind of birthday every day at 09.00 AM
    {"0 0 09 * *", {Memento.BirthdayReminder, :run, []}}
  ]

import_config "#{Mix.env()}.exs"
