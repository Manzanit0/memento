DATABASE_URL ?= 'postgres://postgres:docker@localhost:5432/memento_dev'

# Stops local postgres server if it's running and starts a docker one if it
# isn't already running.
postgres:
	! /etc/init.d/postgresql status || sudo /etc/init.d/postgresql stop && \
	mkdir -p ~/docker/volumes/postgres && \
	docker start pg-docker || docker run --rm --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v ~/docker/volumes/postgres:/var/lib/postgresql/data postgres

pgcli:
	pgcli $(DATABASE_URL)

reset-db:
	mix do ecto.drop, ecto.create, ecto.migrate

start:
	mix ecto.migrate && iex -S mix

set-telegram-webhook:
	curl -X POST https://api.telegram.org/bot$(TELEGRAM_TOKEN)/setWebhook?url=$(HOST)/api/telegram