import Config

config :memento, Memento.Repo,
  database: "memento_dev",
  username: "postgres",
  password: "docker",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true
