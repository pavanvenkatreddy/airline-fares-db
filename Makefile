DOCKER_BIN_DIR := $(shell if [ -x /Applications/Docker.app/Contents/Resources/bin/docker ]; then echo /Applications/Docker.app/Contents/Resources/bin; fi)
export PATH := $(DOCKER_BIN_DIR):$(PATH)

DC := $(shell if docker compose version >/dev/null 2>&1; then echo "docker compose"; elif command -v docker-compose >/dev/null 2>&1; then echo "docker-compose"; fi)

.PHONY: check doctor ensure-up up down reset psql logs

check:
	@./scripts/check_prereqs.sh

doctor: check

up: check
	@$(DC) up -d

ensure-up: check
	@$(DC) up -d postgres

down: check
	@$(DC) down

reset: check
	@./scripts/reset_db.sh

psql: ensure-up
	@$(DC) exec postgres psql -U airlineuser -d airlinefares

logs: ensure-up
	@$(DC) logs -f postgres
