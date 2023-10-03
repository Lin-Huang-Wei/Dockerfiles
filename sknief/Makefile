# Maintainer: Daniel Lin
# Update: 2023-10-04

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

# Set defaults AWSCLIv2_VERSION, if variable have be setting, will be replaced.
ifndef AWSCLIv2_VERSION
	override AWSCLIv2_VERSION=2.13.21
endif

# Set defaults TF_VERSION, if variable have be setting, will be replaced.
ifndef TF_VERSION
	override TF_VERSION=1.5.7
endif

# Set defaults ANSIBLE_VERSION, if variable have be setting, will be replaced.
ifndef ANSIBLE_VERSION
	override ANSIBLE_VERSION=2.14.5
endif

# Set defaults KUBECTL_VERSION, if variable have be setting, will be replaced.
ifndef KUBECTL_VERSION
	override KUBECTL_VERSION=1.27.1
endif

# Set defaults KREW_VERSION, if variable have be setting, will be replaced.
ifndef KREW_VERSION
	override KREW_VERSION=0.4.4
endif

# Set defaults HELM_VERSION, if variable have be setting, will be replaced.
ifndef HELM_VERSION
	override HELM_VERSION=3.12.3
endif

# Set defaults TEKTON_VERSION, if variable have be setting, will be replaced.
ifndef TEKTON_VERSION
	override TEKTON_VERSION=0.32.0
endif

# Set defaults GOLANG_VERSION, if variable have be setting, will be replaced.
ifndef GOLANG_VERSION
	override GOLANG_VERSION=1.21.1
endif

# Set defaults K9S_VERSION, if variable have be setting, will be replaced.
ifndef K9S_VERSION
	override K9S_VERSION=0.27.4
endif

# Set defaults NEOVIM_VERSION, if variable have be setting, will be replaced.
ifndef NEOVIM_VERSION
	override NEOVIM_VERSION=0.9.2
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
build: ## Build sknief docker images from Dockerfile, defaults AWSCLIv2_VERSION=2.11.6, TF_VERSION=1.4.6, ANSIBLE_VERSION=2.14.5, KUBECTL_VERSION=1.27.1, HELM_VERSION=3.11.3, TEKTON_VERSION=0.30.1, GOLANG_VERSION=1.20.3
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sStart${RESET} ${CYAN}Swiss Knief${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}%-4sAWSCLIv2_VERSION=${RESET}${MAGENTA}${AWSCLIv2_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTF_VERSION=${RESET}${MAGENTA}${TF_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sANSIBLE_VERSION=${RESET}${MAGENTA}${ANSIBLE_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sKUBECTL_VERSION=${RESET}${MAGENTA}${KUBECTL_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sKREW_VERSION=${RESET}${MAGENTA}${KREW_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sHELM_VERSION=${RESET}${MAGENTA}${HELM_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTEKTON_VERSION=${RESET}${MAGENTA}${TEKTON_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sGOLANG_VERSION=${RESET}${MAGENTA}${GOLANG_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sK9S_VERSION=${RESET}${MAGENTA}${K9S_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sNEOVIM_VERSION=${RESET}${MAGENTA}${NEOVIM_VERSION}${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@docker build \
		--build-arg buildtime_AWSCLIv2_VERSION=$(AWSCLIv2_VERSION) \
		--build-arg buildtime_TF_VERSION=$(TF_VERSION) \
		--build-arg buildtime_ANSIBLE_VERSION=$(ANSIBLE_VERSION) \
		--build-arg buildtime_KUBECTL_VERSION=$(KUBECTL_VERSION) \
		--build-arg buildtime_KREW_VERSION=$(KREW_VERSION) \
		--build-arg buildtime_HELM_VERSION=$(HELM_VERSION) \
		--build-arg buildtime_TEKTON_VERSION=$(TEKTON_VERSION) \
		--build-arg buildtime_K9S_VERSION=$(K9S_VERSION) \
		--build-arg buildtime_NEOVIM_VERSION=$(NEOVIM_VERSION) \
		-t $(DOCKERHUB_ACCOUNT)/sknief -f Dockerfile .

.PHONY: run
run: ## Start running Terraform container, when you exit container, container will be delete, defaults AWSCLIv2_VERSION=2.11.6, TF_VERSION=1.4.6, ANSIBLE_VERSION=2.14.5, KUBECTL_VERSION=1.27.1, HELM_VERSION=3.11.3, TEKTON_VERSION=0.30.1, GOLANG_VERSION=1.20.3
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sStart${RESET} ${CYAN}Swiss Knief${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}%-4sAWSCLIv2_VERSION=${RESET}${MAGENTA}${AWSCLIv2_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTF_VERSION=${RESET}${MAGENTA}${TF_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sANSIBLE_VERSION=${RESET}${MAGENTA}${ANSIBLE_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sKUBECTL_VERSION=${RESET}${MAGENTA}${KUBECTL_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sKREW_VERSION=${RESET}${MAGENTA}${KREW_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sHELM_VERSION=${RESET}${MAGENTA}${HELM_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTEKTON_VERSION=${RESET}${MAGENTA}${TEKTON_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sGOLANG_VERSION=${RESET}${MAGENTA}${GOLANG_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sK9S_VERSION=${RESET}${MAGENTA}${K9S_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sNEOVIM_VERSION=${RESET}${MAGENTA}${NEOVIM_VERSION}${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@docker run --name sknief -d  \
		--volume "${shell PWD}/../ansible:/work/ansible" \
		--volume "${shell PWD}/../terraform:/work/terraform" \
		-it $(DOCKERHUB_ACCOUNT)/sknief bash

.PHONY: clean
clean: ## Garbage disposal
	@docker rmi -f $(CONTAINER_IMAGES_PURGE)
	@docker rm -f $(CONTAINER_CLEAN)

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n${YELLOW}Usage:${RESET}\n  make ${CYAN}<target>${RESET}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${CYAN}%-15s${RESET} %s\n", $$1, $$2 } /^##@/ { printf "\n${YELLOW}%s${RESET}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
