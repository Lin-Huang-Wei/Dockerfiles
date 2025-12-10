# Maintainer: Daniel Lin
# Update: 2025-08-20

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
WORK_DIR               := ${shell PWD}
CONTAINER_IMAGES_PURGE := $(shell docker images -q -f dangling=true)
CONTAINER_CLEAN        := $(shell docker ps -qa -f status=exited)

CONTAINER_NAME         := diagrams


# Set DockerHub Account Name
ifndef DOCKERHUB_ACCOUNT
	override DOCKERHUB_ACCOUNT=demo
endif

##@ Docker

.PHONY: show
show: ## Show current running container
	@docker container ls

.PHONY: build
build: ## Build diagrams docker images from Dockerfile
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sStart${RESET} ${CYAN}Diagrams${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@docker build \
		-t $(DOCKERHUB_ACCOUNT)/$(CONTAINER_NAME) -f Dockerfile .

.PHONY: run
run: ## Start running Terraform container, when you exit container, container will be delete
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sStart${RESET} ${CYAN}Diagrams${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@file=$(filter-out run,$(MAKECMDGOALS)); \
	echo "File: $$file"; \
	if [ -z "$$file" ]; then \
		echo "No file specified"; \
		exit 1; \
	elif [ ! -f "$$file" ]; then \
		echo "Error: File '$$file' does not exist"; \
		exit 1; \
	else \
		echo "Processing file: $$file"; \
	fi; \
	docker run --rm --name $(CONTAINER_NAME) \
		--volume "$(shell PWD)":/diagrams/scripts/ \
		--workdir /diagrams/scripts/ \
		-it $(DOCKERHUB_ACCOUNT)/$(CONTAINER_NAME) "$$file"

.PHONY: clean
clean: ## Garbage disposal
	@docker rmi -f $(CONTAINER_IMAGES_PURGE)
	@docker rm -f $(CONTAINER_CLEAN)

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n${YELLOW}Usage:${RESET}\n  make ${CYAN}<target>${RESET}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${CYAN}%-15s${RESET} %s\n", $$1, $$2 } /^##@/ { printf "\n${YELLOW}%s${RESET}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
