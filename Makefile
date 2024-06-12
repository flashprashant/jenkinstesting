export UID := $(shell id -u)
export GID := $(shell id -g)

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help

build: ## Build the build image
	@docker compose build --no-cache build

install: ## Installs composer dependencies
	@docker compose run --entrypoint=/usr/local/bin/composer build install

test: ## Execute unit/integration tests
test: install
	@docker compose run --entrypoint=/usr/local/bin/composer build test

shell: ## Start a shell
	@docker compose run --entrypoint=/bin/bash build

clean-docker: ## Cleanup docker environment
	@docker compose down -v --remove-orphans
	@docker compose rm -sf

clean: ## Cleanup
clean: clean-docker
