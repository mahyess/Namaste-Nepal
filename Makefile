THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help build up start down destroy stop restart logs logs-api ps login-backend login-db db-shell makemigrations migrate
.DEFAULT_GOAL := help

help: ## helps
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

setup: ## setup
	@echo "setup init"
	@cp -R -u -p ./backend/.env.template ./backend/.env
	@make build
	@echo "setup complete"

makemigrations: ## Create Django Migration files
	docker-compose exec backend python manage.py makemigrations $(c)

migrate: ## Migrate Django Migrations to DB
	docker-compose exec backend python manage.py migrate $(c)

shell: ## Open Django Shell
	docker-compose exec backend python manage.py shell $(c)

flush: ## Flush Db
	docker-compose exec backend python manage.py flush --noinput

build: ## Build Docker Images
	docker-compose -f docker-compose.yml build $(c)

up: ## Start Docker Containers
	docker-compose -f docker-compose.yml up -d $(c)

start: ## Start Docker Containers if stopped. Same as up but less preferred.
	docker-compose -f docker-compose.yml start $(c)

down: ## Stop Docker Containers and removes the stopped containers
	docker-compose -f docker-compose.yml down $(c)

destroy: ## Remove Docker Containers
	docker-compose -f docker-compose.yml down -v $(c)

stop: ## Stop Docker Containers
	docker-compose -f docker-compose.yml stop $(c)

restart: ## Restart Docker Containers
	docker-compose -f docker-compose.yml stop $(c)
	docker-compose -f docker-compose.yml up -d $(c)

logs: ## Show Docker Container Logs
	docker-compose -f docker-compose.yml logs --tail=100 -f $(c)

logs-backend: ## Show Docker Container Logs but only of django app
	docker-compose -f docker-compose.yml logs --tail=100 -f backend

ps: ## Show Docker Container Status
	docker-compose -f docker-compose.yml ps

login-db: ## Login to DB in bash shell
	docker-compose -f docker-compose.yml exec db /bin/bash

login-backend: ## Login to Django app in bash shell
	docker-compose -f docker-compose.yml exec backend /bin/bash

db-shell: ## Login to DB in bash shell as postgres user
	docker-compose -f docker-compose.yml exec db psql -Upostgres

pyinstall: ## install a poetry package
	@echo "init install package"
	@docker-compose -f docker-compose.yml run --rm backend poetry add $(c)
	@make build
	@make restart
	@echo "complete install package"

install-ssl: ## install ssl
	docker-compose -f docker-compose.prod.yml run --rm  certbot certonly --webroot --webroot-path /var/www/certbot/ -d merogarage.aptcluster.com -d *.merogarage.aptcluster.com

renew-ssl: ## renew ssl
	docker compose -f docker-compose.prod.yml run --rm certbot renew