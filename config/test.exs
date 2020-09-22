import Config

config :memento, Memento.Repo,
  username: "postgres",
  password: "docker",
  hostname: "localhost",
  database: "memento_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox
