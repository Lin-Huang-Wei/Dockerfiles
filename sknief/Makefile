# Maintainer: Daniel Lin
# Update: 2023-04-30

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

# Set defaults AWSCLIv2_VERSION, if variable have be setting, will be replaced.
ifndef AWSCLIv2_VERSION
	override AWSCLIv2_VERSION=2.11.6
endif

# Set defaults TF_VERSION, if variable have be setting, will be replaced.
ifndef TF_VERSION
	override TF_VERSION=1.4.6
endif

# Set defaults ANSIBLE_VERSION, if variable have be setting, will be replaced.
ifndef ANSIBLE_VERSION
	override ANSIBLE_VERSION=2.14.5
endif

# Set defaults ANSIBLE_VERSION, if variable have be setting, will be replaced.
ifndef KUBECTL_VERSION
	override KUBECTL_VERSION=1.27.1
endif

# Set defaults HELM_VERSION, if variable have be setting, will be replaced.
ifndef HELM_VERSION
	override HELM_VERSION=3.11.3
endif

# Set defaults ANSIBLE_VERSION, if variable have be setting, will be replaced.
ifndef TEKTON_VERSION
	override TEKTON_VERSION=0.30.1
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
build: ## Build Terraform docker images from Dockerfile, defaults AWSCLIv2_VERSION=2.11.6, TF_VERSION=1.4.6, ANSIBLE_VERSION=2.14.5, KUBECTL_VERSION=1.27.1, HELM_VERSION=3.11.3, TEKTON_VERSION=0.30.1
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sStart${RESET} ${CYAN}Swiss Knief${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}%-4sAWSCLIv2_VERSION=${RESET}${MAGENTA}${AWSCLIv2_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTF_VERSION=${RESET}${MAGENTA}${TF_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sANSIBLE_VERSION=${RESET}${MAGENTA}${ANSIBLE_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sKUBECTL_VERSION=${RESET}${MAGENTA}${KUBECTL_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sHELM_VERSION=${RESET}${MAGENTA}${HELM_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTEKTON_VERSION=${RESET}${MAGENTA}${TEKTON_VERSION}${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@docker build \
		--build-arg buildtime_AWSCLIv2_VERSION=$(AWSCLIv2_VERSION) \
		--build-arg buildtime_TF_VERSION=$(TF_VERSION) \
		--build-arg buildtime_ANSIBLE_VERSION=$(ANSIBLE_VERSION) \
		--build-arg buildtime_KUBECTL_VERSION=$(KUBECTL_VERSION) \
		--build-arg buildtime_HELM_VERSION=$(HELM_VERSION) \
		--build-arg buildtime_TEKTON_VERSION=$(TEKTON_VERSION) \
		-t $(DOCKERHUB_ACCOUNT)/sknief -f Dockerfile .

.PHONY: run
run: ## Start running Terraform container, when you exit container, container will be delete, defaults AWSCLIv2_VERSION=2.11.6, TF_VERSION=1.4.6, ANSIBLE_VERSION=2.14.5, KUBECTL_VERSION=1.27.1, HELM_VERSION=3.11.3, TEKTON_VERSION=0.30.1
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@printf "${YELLOW}%-2sStart${RESET} ${CYAN}Swiss Knief${RESET} ${YELLOW}Container Images${RESET}\n"
	@printf "${YELLOW}%-4sAWSCLIv2_VERSION=${RESET}${MAGENTA}${AWSCLIv2_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTF_VERSION=${RESET}${MAGENTA}${TF_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sANSIBLE_VERSION=${RESET}${MAGENTA}${ANSIBLE_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sKUBECTL_VERSION=${RESET}${MAGENTA}${KUBECTL_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sHELM_VERSION=${RESET}${MAGENTA}${HELM_VERSION}${RESET}\n"
	@printf "${YELLOW}%-4sTEKTON_VERSION=${RESET}${MAGENTA}${TEKTON_VERSION}${RESET}\n"
	@printf "${YELLOW}########################################################################################################################${RESET}\n"
	@docker run --name sknief -d  \
		--volume "${shell PWD}/../ansible:/work/ansible" \
		--volume "${shell PWD}/../terraform:/work/terraform" \
		-it $(DOCKERHUB_ACCOUNT)/sknief bash

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n${YELLOW}Usage:${RESET}\n  make ${CYAN}<target>${RESET}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${CYAN}%-15s${RESET} %s\n", $$1, $$2 } /^##@/ { printf "\n${YELLOW}%s${RESET}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)