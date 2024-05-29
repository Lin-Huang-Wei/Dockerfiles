# Maintainer: Daniel Lin
# Update: 2024-05-29

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
DIRECTORIES            := ansible terraform tekton
CONTAINER_IMAGES_PURGE := $(shell docker images -q -f dangling=true)
CONTAINER_CLEAN        := $(shell docker ps -qa -f status=exited)

CONTAINER_NAME         := mosquito


# Set defaults AWSCLIv2_VERSION, if variable have be setting, will be replaced.
ifndef AWSCLIv2_VERSION
	override AWSCLIv2_VERSION=2.15.6
endif

# Set defaults AZ_VERSION, if variable have be setting, will be replaced.
ifndef AZ_VERSION
	override AZ_VERSION=2.55.0
endif

# Set defaults TF_VERSION, if variable have be setting, will be replaced.
ifndef TF_VERSION
	override TF_VERSION=1.8.3
endif

# Set defaults ANSIBLE_VERSION, if variable have be setting, will be replaced.
ifndef ANSIBLE_VERSION
	override ANSIBLE_VERSION=2.17.0
endif

# Set defaults KUBECTL_VERSION, if variable have be setting, will be replaced.
ifndef KUBECTL_VERSION
	override KUBECTL_VERSION=1.28.5
endif

# Set defaults KREW_VERSION, if variable have be setting, will be replaced.
ifndef KREW_VERSION
	override KREW_VERSION=0.4.4
endif

# Set defaults HELM_VERSION, if variable have be setting, will be replaced.
ifndef HELM_VERSION
	override HELM_VERSION=3.13.3
endif

# Set defaults TEKTON_VERSION, if variable have be setting, will be replaced.
ifndef TEKTON_VERSION
	override TEKTON_VERSION=0.33.0
endif

# Set defaults GOLANG_VERSION, if variable have be setting, will be replaced.
ifndef GOLANG_VERSION
	override GOLANG_VERSION=1.21.1
endif

# Set defaults K9S_VERSION, if variable have be setting, will be replaced.
ifndef K9S_VERSION
	override K9S_VERSION=0.30.6
endif

# Set defaults YQ_VERSION, if variable have be setting, will be replaced.
ifndef YQ_VERSION
	override YQ_VERSION=4.40.5
endif

# Set defaults NEOVIM_VERSION, if variable have be setting, will be replaced.
ifndef NEOVIM_VERSION
	override NEOVIM_VERSION=0.9.5
endif

# Set defaults NEOVIM_VERSION, if variable have be setting, will be replaced.
ifndef GUM_VERSION
	override GUM_VERSION=0.13.0
endif

# Set DockerHub Account Name
ifndef DOCKERHUB_ACCOUNT
	override DOCKERHUB_ACCOUNT=daniel
endif

##@ Docker

.PHONY: show
show: ## Show current running container
	@docker container ls

.PHONY: build
build: ## Build mosquito docker images from Dockerfile
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sStart${RESET} ${CYAN}Swiss Knief${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}%-4sNEOVIM_VERSION=${RESET}${MAGENTA}${NEOVIM_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTF_VERSION=${RESET}${MAGENTA}${TF_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sANSIBLE_VERSION=${RESET}${MAGENTA}${ANSIBLE_VERSION}${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@docker build \
		--build-arg buildtime_NEOVIM_VERSION=$(NEOVIM_VERSION) \
		--build-arg buildtime_TF_VERSION=$(TF_VERSION) \
		--build-arg buildtime_ANSIBLE_VERSION=$(ANSIBLE_VERSION) \
		-t $(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME} -f Dockerfile .

.PHONY: run
run: ## Start running Terraform container, when you exit container, container will be deleted
	@for dir in $(DIRECTORIES); do \
		if [ ! -d "${WORK_DIR}/$${dir}" ]; then \
			echo "${GREEN}[INFO]${RESET} Create a directory ${WORK_DIR}/$${dir}"; \
			mkdir -p "${WORK_DIR}/$${dir}"; \
		fi \
	done
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sStart${RESET} ${CYAN}Swiss Knife${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}%-4sNEOVIM_VERSION=${RESET}${MAGENTA}${NEOVIM_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTF_VERSION=${RESET}${MAGENTA}${TF_VERSION}${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@docker run --name ${CONTAINER_NAME} \
		--volume "${shell PWD}/../../HomeLab/terraform/:/work/terraform" \
		--volume "${shell PWD}/tekton:/work/tekton/" \
		--volume "${shell PWD}/ansible/:/work/ansible" \
		--volume "/Users/daniel/.ssh:/root/.ssh" \
		--privileged -it $(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME} bash


.PHONY: clean
clean: ## Garbage disposal
	@docker rmi -f $(CONTAINER_IMAGES_PURGE)
	@docker rm -f $(CONTAINER_CLEAN)

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n${YELLOW}Usage:${RESET}\n  make ${CYAN}<target>${RESET}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${CYAN}%-15s${RESET} %s\n", $$1, $$2 } /^##@/ { printf "\n${YELLOW}%s${RESET}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
