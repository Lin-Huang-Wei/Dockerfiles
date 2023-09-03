# Maintainer: Daniel Lin
# Update: 2023-08-29

SHELL := /bin/bash

.DEFAULT_GOAL := help

RED                    := $(shell tput -Txterm setaf 1)
GREEN                  := $(shell tput -Txterm setaf 2)
YELLOW                 := $(shell tput -Txterm setaf 3)
BLUE                   := $(shell tput -Txterm setaf 4)
MAGENTA                := $(shell tput -Txterm setaf 5)
CYAN                   := $(shell tput -Txterm setaf 6)
WHITE                  := $(shell tput -Txterm setaf 7)
RESET                  := $(shell tput -Txterm sgr0)

MKFILE_PATH            := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR               := $(shell dirname $(MKFILE_PATH))
DOCKER_COMPOSE         := $(shell which docker-compose)
CONTAINER_IMAGES_PURGE := $(shell docker images -q -f dangling=true)
CONTAINER_CLEAN        := $(shell docker ps -qa -f status=exited)
FOLDERS                := mssql/data mssql/log projects

##@ Docker

.PHONY: show
show: ## Show current running container
	@docker container ls

.PHONY: build
build: ## Build container images from Dockerfile, defaults MSODBCSQL=msodbcsql18 MSODBCSQL_TOOL=mssql-tools18
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sBuilding the${RESET} ${CYAN}MSSQL${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}%-2sBuilding the${RESET} ${CYAN}Django${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@${DOCKER_COMPOSE} build

.PHONY: create_dirs change_permissions
create_dirs: $(FOLDERS) change_permissions
$(FOLDERS):
	@if [ ! -d $@ ]; then \
		printf "${YELLOW}Creating $@ folder...${RESET}\n"; \
        mkdir -p $@; \
    else \
        printf "${MAGENTA}$@ folder already exists.${RESET}\n"; \
    fi

change_permissions:
	@sudo chgrp -R 0 $(PWD)/mssql
	@sudo chmod -R g=u  $(PWD)/mssql
	@sudo chown -R 10001:0 $(PWD)/mssql

.PHONY: create_dirs change_permissions run
run: create_dirs change_permissions ## Start container
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@${DOCKER_COMPOSE} up -d
	@printf "${YELLOW}########################################################################################################################${RESET}\n"

.PHONY: restart
restart: ## Restart container
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@${DOCKER_COMPOSE} restart
	@printf "${YELLOW}########################################################################################################################${RESET}\n"

.PHONY: stop
stop: ## Stop container
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@${DOCKER_COMPOSE} stop
	@printf "${YELLOW}########################################################################################################################${RESET}\n"

.PHONY: down
down: ## Remove all container
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@${DOCKER_COMPOSE} stop && ${DOCKER_COMPOSE} down
	@printf "${YELLOW}########################################################################################################################${RESET}\n"

.PHONY: clean 
clean: ## Garbage disposal
	@docker rmi -f $(CONTAINER_IMAGES_PURGE) || true
	@docker rm -f $(CONTAINER_CLEAN) || true

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n${YELLOW}Usage:${RESET}\n  make ${CYAN}<target>${RESET}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${CYAN}%-15s${RESET} %s\n", $$1, $$2 } /^##@/ { printf "\n${YELLOW}%s${RESET}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)