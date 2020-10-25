import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :memento, Memento.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: database_url,
  database: "",
  # ssl: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :memento, :telegram_token, System.fetch_env!("TELEGRAM_BOT_TOKEN")
