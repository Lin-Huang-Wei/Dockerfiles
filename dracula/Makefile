# Update: 2025-08-10
# Maintainer: Daniel Lin

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

LOWER_ARCH             := $(shell uname -m)

USER_SHELL             := $(shell echo $$SHELL)
ifeq ($(USER_SHELL), /bin/zsh)
	USER_RC                := ${HOME}/.zshrc
else ifeq ($(USER_SHELL), /bin/bash)
	USER_RC								 := ${HOME}/.bashrc
endif

CLOUDSDK_CONFIG        := config/gcloud

# 設定平台
PLATFORMS := linux/arm64
MAP_PLATFORMS := arm64
# PLATFORMS := linux/amd64
# MAP_PLATFORMS := amd64
# PLATFORMS := linux/amd64 linux/arm64
# MAP_PLATFORMS := amd64 arm64

CONTAINER_IMAGES_PURGE := $(shell docker images -q -f dangling=true)
CONTAINER_CLEAN        := $(shell docker ps -qa -f status=exited)
CONTAINER_NAME         := dracula

# Set defaults ANSIBLE_VERSION, if variable have be setting, will be replaced.
ifndef ANSIBLE_VERSION
	override ANSIBLE_VERSION=2.20.0
endif

# Set defaults DOCKER_VERSION, if variable have be setting, will be replaced.
# https://download.docker.com/linux/static/stable/x86_64/
ifndef DOCKER_VERSION
	override DOCKER_VERSION=29.0.4
endif

# Set defaults DOCKER_COMPOSE_VERSION, if variable have be setting, will be replaced.
# https://github.com/docker/compose/releases/
ifndef DOCKER_COMPOSE_VERSION
	override DOCKER_COMPOSE_VERSION=2.40.3
endif

# Set defaults BUILDX_VERSION, if variable have be setting, will be replaced.
# https://github.com/docker/buildx/releases
ifndef BUILDX_VERSION
	override BUILDX_VERSION=0.30.1
endif

# Set defaults AWSCLIv2_VERSION, if variable have be setting, will be replaced.
# https://github.com/aws/aws-cli/tags
ifndef AWSCLIv2_VERSION
	override AWSCLIv2_VERSION=2.32.5
endif

# Set defaults AZ_VERSION, if variable have be setting, will be replaced.
# https://github.com/azure/azure-cli/releases
ifndef AZ_VERSION
	override AZ_VERSION=2.80.0
endif

# Set defaults GCPCLI_VERSION, if variable have be setting, will be replaced.
# https://cloud.google.com/sdk/docs/release-notes
ifndef GCPCLI_VERSION
	override GCPCLI_VERSION=548.0.0-0
endif

# Set defaults DOCKER_CREDENTIAL_GCR_VERSION, if variable have be setting, will be replaced.
# https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases
ifndef DOCKER_CREDENTIAL_GCR_VERSION
	override DOCKER_CREDENTIAL_GCR_VERSION=2.1.30
endif

# Set defaults TF_VERSION, if variable have be setting, will be replaced.
# https://github.com/hashicorp/terraform/releases
ifndef TF_VERSION
	override TF_VERSION=1.14.0
endif

# Set defaults KUBECTL_VERSION, if variable have be setting, will be replaced.
# https://github.com/kubernetes/kubectl/tags
ifndef KUBECTL_VERSION
	override KUBECTL_VERSION=1.34.2
endif

# Set defaults KREW_VERSION, if variable have be setting, will be replaced.
# https://github.com/kubernetes-sigs/krew/releases
ifndef KREW_VERSION
	override KREW_VERSION=0.4.5
endif

# Set defaults KUSTOMIZE_VERSION, if variable have be setting, will be replaced.
# https://github.com/kubernetes-sigs/kustomize/releases
ifndef KUSTOMIZE_VERSION
	override KUSTOMIZE_VERSION=5.8.0
endif

# Set defaults HELM_VERSION, if variable have be setting, will be replaced.
# https://github.com/helm/helm/releases
ifndef HELM_VERSION
	override HELM_VERSION=4.0.1
endif

# Set defaults TEKTON_VERSION, if variable have be setting, will be replaced.
# https://github.com/tektoncd/cli/releases
ifndef TEKTON_VERSION
	override TEKTON_VERSION=0.43.0
endif

# Set defaults GOLANG_VERSION, if variable have be setting, will be replaced.
# https://go.dev/doc/devel/release
ifndef GOLANG_VERSION
	override GOLANG_VERSION=1.25.0
endif

# Set defaults K9S_VERSION, if variable have be setting, will be replaced.
# https://github.com/derailed/k9s/releases
ifndef K9S_VERSION
	override K9S_VERSION=0.50.16
endif

# Set defaults LOKI_VERSION, if variable have be setting, will be replaced.
# https://github.com/grafana/loki/releases
ifndef LOKI_VERSION
	override LOKI_VERSION=3.6.2
endif

# Set defaults YQ_VERSION, if variable have be setting, will be replaced.
# https://github.com/mikefarah/yq/releases
ifndef YQ_VERSION
	override YQ_VERSION=4.49.2
endif

# Set defaults NEOVIM_VERSION, if variable have be setting, will be replaced.
# https://github.com/charmbracelet/gum
ifndef GUM_VERSION
	override GUM_VERSION=0.17.0
endif

# # Set defaults NEOVIM_VERSION, if variable have be setting, will be replaced.
# ifndef NEOVIM_VERSION
# 	override NEOVIM_VERSION=0.10.3
# endif

# Set defaults INFRACOST_VERSION, if variable have be setting, will be replaced.
# https://github.com/infracost/infracost/releases
ifndef INFRACOST_VERSION
	override INFRACOST_VERSION=0.10.42
endif

# Set DockerHub Account Name
ifndef DOCKERHUB_ACCOUNT
	override DOCKERHUB_ACCOUNT=zarr12steven
endif

# Define a function for duplicate usage when typing make run
define running_platform
	printf "${YELLOW}########################################################################################################################${RESET}\n"; \
	printf "${YELLOW}%-2sBuilding Platform${RESET} ${CYAN}$${PLATFORM}${RESET}\n"; \
	printf "${YELLOW}%-2sMap Platform${RESET} ${CYAN}$${MAP_PLATFORM}${RESET}\n"; \
	printf "${YELLOW}%-2sStart running ${RESET} ${CYAN}$(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME}-$${MAP_PLATFORM}${RESET} ${YELLOW}Container Images${RESET}\n"; \
	printf "${YELLOW}%-4sANSIBLE_VERSION=${RESET}${MAGENTA}${ANSIBLE_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sDOCKER_VERSION=${RESET}${MAGENTA}${DOCKER_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sDOCKER_COMPOSE_VERSION=${RESET}${MAGENTA}${DOCKER_COMPOSE_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sBUILDX_VERSION=${RESET}${MAGENTA}${BUILDX_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sAWSCLIv2_VERSION_VERSION=${RESET}${MAGENTA}${AWSCLIv2_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sAZ_VERSION_VERSION=${RESET}${MAGENTA}${AZ_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sGCPCLI_VERSION=${RESET}${MAGENTA}${GCPCLI_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sDOCKER_CREDENTIAL_GCR_VERSION=${RESET}${MAGENTA}${DOCKER_CREDENTIAL_GCR_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sTF_VERSION=${RESET}${MAGENTA}${TF_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sKUBECTL_VERSION=${RESET}${MAGENTA}${KUBECTL_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sKREW_VERSION=${RESET}${MAGENTA}${KREW_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sKUSTOMIZE_VERSION=${RESET}${MAGENTA}${KUSTOMIZE_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sHELM_VERSION=${RESET}${MAGENTA}${HELM_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sTEKTON_VERSION=${RESET}${MAGENTA}${TEKTON_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sGOLANG_VERSION=${RESET}${MAGENTA}${GOLANG_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sK9S_VERSION=${RESET}${MAGENTA}${K9S_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sLOKI_VERSION=${RESET}${MAGENTA}${LOKI_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sYQ_VERSION=${RESET}${MAGENTA}${YQ_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sGUM_VERSION=${RESET}${MAGENTA}${GUM_VERSION}${RESET}\n"; \
	printf "${YELLOW}%-4sINFRACOST_VERSION=${RESET}${MAGENTA}${INFRACOST_VERSION}${RESET}\n"; \
	printf "${YELLOW}########################################################################################################################${RESET}\n"; \
	docker run --name ${CONTAINER_NAME}-$${MAP_PLATFORM} \
		--volume "${shell PWD}/../../../../HomeLab/terraform/:/work/terraform" \
		--volume "${shell PWD}/../../tekton:/work/tekton/" \
		--volume "${shell PWD}/../../ansible/:/work/ansible" \
		--volume "${shell PWD}/../../gke/:/work/gke" \
		--volume "$${HOME}/.azure:/root/.azure" \
		--volume "$${HOME}/.config/gcloud:/root/.config/gcloud" \
		--volume "$${HOME}/.ssh:/root/.ssh" \
		--volume "$${HOME}/.tmux.conf:/root/.tmux.conf" \
		--privileged -it $(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME}-$${MAP_PLATFORM} bash
endef

##@ Docker

.PHONY: show
show: ## Show current running container
	@docker container ls -a

.PHONY: build
build: ## Build mosquito docker images from Dockerfile
	@platforms_list="$(PLATFORMS)"; \
	map_list="$(MAP_PLATFORMS)"; \
	platforms_array=($$platforms_list); \
	map_array=($$map_list); \
	for i in $$(seq 0 $$(( $$(echo $$platforms_list | wc -w) - 1 ))); do \
		platform=$${platforms_array[$$i]}; \
		map_platform=$${map_array[$$i]}; \
		printf "${YELLOW}########################################################################################################################${RESET}\n"; \
		printf "${YELLOW}%-2sBuilding Platform${RESET} ${CYAN}$${platform}${RESET}\n"; \
		printf "${YELLOW}%-2sMap Platform${RESET} ${CYAN}$${map_platform}${RESET}\n"; \
		printf "${YELLOW}%-2sStart building ${RESET} ${CYAN}$(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME}-$${map_platform}${RESET} ${YELLOW}Container Images${RESET}\n"; \
		printf "${YELLOW}%-4sANSIBLE_VERSION=${RESET}${MAGENTA}${ANSIBLE_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sDOCKER_VERSION=${RESET}${MAGENTA}${DOCKER_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sDOCKER_COMPOSE_VERSION=${RESET}${MAGENTA}${DOCKER_COMPOSE_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sBUILDX_VERSION=${RESET}${MAGENTA}${BUILDX_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sAWSCLIv2_VERSION_VERSION=${RESET}${MAGENTA}${AWSCLIv2_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sAZ_VERSION_VERSION=${RESET}${MAGENTA}${AZ_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sGCPCLI_VERSION=${RESET}${MAGENTA}${GCPCLI_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sDOCKER_CREDENTIAL_GCR_VERSION=${RESET}${MAGENTA}${DOCKER_CREDENTIAL_GCR_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sTF_VERSION=${RESET}${MAGENTA}${TF_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sKUBECTL_VERSION=${RESET}${MAGENTA}${KUBECTL_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sKREW_VERSION=${RESET}${MAGENTA}${KREW_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sKUSTOMIZE_VERSION=${RESET}${MAGENTA}${KUSTOMIZE_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sHELM_VERSION=${RESET}${MAGENTA}${HELM_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sTEKTON_VERSION=${RESET}${MAGENTA}${TEKTON_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sGOLANG_VERSION=${RESET}${MAGENTA}${GOLANG_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sK9S_VERSION=${RESET}${MAGENTA}${K9S_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sLOKI_VERSION=${RESET}${MAGENTA}${LOKI_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sYQ_VERSION=${RESET}${MAGENTA}${YQ_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sGUM_VERSION=${RESET}${MAGENTA}${GUM_VERSION}${RESET}\n"; \
		printf "${YELLOW}%-4sINFRACOST_VERSION=${RESET}${MAGENTA}${INFRACOST_VERSION}${RESET}\n"; \
		printf "${YELLOW}########################################################################################################################${RESET}\n"; \
		docker buildx build --no-cache --platform=$${platform} \
			--build-arg TARGETPLATFORM=$${platform} \
			--build-arg buildtime_ANSIBLE_VERSION=$(ANSIBLE_VERSION) \
			--build-arg buildtime_DOCKER_VERSION=$(DOCKER_VERSION) \
			--build-arg buildtime_DOCKER_COMPOSE_VERSION=$(DOCKER_COMPOSE_VERSION) \
			--build-arg buildtime_BUILDX_VERSION=$(BUILDX_VERSION) \
			--build-arg buildtime_AWSCLIv2_VERSION=$(AWSCLIv2_VERSION) \
			--build-arg buildtime_AZ_VERSION=$(AZ_VERSION) \
			--build-arg buildtime_GCPCLI_VERSION=$(GCPCLI_VERSION) \
			--build-arg buildtime_DOCKER_CREDENTIAL_GCR_VERSION=$(DOCKER_CREDENTIAL_GCR_VERSION) \
			--build-arg buildtime_TF_VERSION=$(TF_VERSION) \
			--build-arg buildtime_KUBECTL_VERSION=$(KUBECTL_VERSION) \
			--build-arg buildtime_KREW_VERSION=$(KREW_VERSION) \
			--build-arg buildtime_KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) \
			--build-arg buildtime_HELM_VERSION=$(HELM_VERSION) \
			--build-arg buildtime_TEKTON_VERSION=$(TEKTON_VERSION) \
			--build-arg buildtime_GOLANG_VERSION=$(GOLANG_VERSION) \
			--build-arg buildtime_K9S_VERSION=$(K9S_VERSION) \
			--build-arg buildtime_LOKI_VERSION=$(LOKI_VERSION) \
			--build-arg buildtime_YQ_VERSION=$(YQ_VERSION) \
			--build-arg buildtime_GUM_VERSION=$(GUM_VERSION) \
			--build-arg buildtime_INFRACOST_VERSION=$(INFRACOST_VERSION) \
			-t $(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME}-$${map_platform} -f Dockerfile .; \
	done

.PHONY: run
run: ## Start running Terraform container, when you exit container, container will be deleted
#	@for dir in $(DIRECTORIES); do \
#		if [ ! -d "${WORK_DIR}/$${dir}" ]; then \
#			echo "${GREEN}[INFO]${RESET} Create a directory ${WORK_DIR}/$${dir}"; \
#			mkdir -p "${WORK_DIR}/$${dir}"; \
#		fi \
#	done
	@if [ ! -d "$(WORK_DIR)/$(CLOUDSDK_CONFIG)" ]; then \
		echo "${GREEN}[INFO]${RESET} Create a directory ${WORK_DIR}/${CLOUDSDK_CONFIG}"; \
		mkdir -p ${WORK_DIR}/${CLOUDSDK_CONFIG}; \
	fi
	@if ! grep -q "CLOUDSDK_CONFIG=${WORK_DIR}/${CLOUDSDK_CONFIG}" "$(USER_RC)"; then \
		echo "${GREEN}[INFO]${RESET} Add CLOUDSDK_CONFIG=${WORK_DIR}/${CLOUDSDK_CONFIG} to $(USER_RC)"; \
		echo "CLOUDSDK_CONFIG=\"${WORK_DIR}/${CLOUDSDK_CONFIG}"\" >> $(USER_RC); \
	fi
	@echo "Please choose a platform:"; \
	platforms_list="$(PLATFORMS)"; \
	map_list="$(MAP_PLATFORMS)"; \
	platforms_array=($$platforms_list); \
	map_array=($$map_list); \
	select choice in $$platforms_list; do \
		case $$choice in \
			linux/amd64) \
				PLATFORM="linux/amd64"; \
				MAP_PLATFORM="amd64"; \
				$(call running_platform,$$PLATFORM,$$MAP_PLATFORM); \
				break; \
				;; \
			linux/arm64) \
				PLATFORM="linux/arm64"; \
				MAP_PLATFORM="arm64"; \
				$(call running_platform,$$PLATFORM,$$MAP_PLATFORM); \
				break; \
				;; \
			*) \
				echo "Invalid choice. Please choose a valid platform."; \
				continue; \
				;; \
		esac; \
	done

.PHONY: attach
attach: ## attach the running container
ifeq ($(LOWER_ARCH), x86_64)
	@CONTAINER_STATUS=$(shell docker ps -a --filter "name=$(CONTAINER_NAME)-amd64" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "running" ]; then \
		printf "[INFO]%-4sContainer ${CYAN}$(CONTAINER_NAME)-amd64${RESET} is ${GREEN}running${RESET}.\n"; \
	fi;
	@docker exec -it $(CONTAINER_NAME)-amd64 bash
else ifeq ($(LOWER_ARCH), arm64)
	@CONTAINER_STATUS=$(shell docker ps -a --filter "name=$(CONTAINER_NAME)-arm64" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "running" ]; then \
		printf "[INFO]%-4sContainer ${CYAN}$(CONTAINER_NAME)-arm64${RESET} is ${GREEN}running${RESET}.\n"; \
	fi;
	@docker exec -it $(CONTAINER_NAME)-arm64 bash
else
	@printf "${RED}[ERROR]${RESET}:%-2sUnknown architecture: ${MAGENTA}$(LOWER_ARCH)${RESET}\n";
endif

.PHONY: reattach
reattach: ## Reattach the existing container
ifeq ($(LOWER_ARCH), x86_64)
	@CONTAINER_STATUS=$(shell docker ps -a --filter "name=$(CONTAINER_NAME)-amd64" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "exited" ]; then \
		printf "${MAGENTA}[WARNING]${RESET}%-1sContainer ${CYAN}$(CONTAINER_NAME)-amd64${RESET} is ${MAGENTA}exited${RESET}. ${YELLOW}Restarting...${RESET}\n"; \
	fi;
	@docker start $(CONTAINER_NAME)-amd64 >> /dev/null; \
		printf "[INFO]%-4sContainer ${CYAN}$(CONTAINER_NAME)-amd64${RESET} is ${GREEN}running${RESET}.\n";
	@docker exec -it $(CONTAINER_NAME)-amd64 bash
else ifeq ($(LOWER_ARCH), arm64)
	@CONTAINER_STATUS=$(shell docker ps -a --filter "name=$(CONTAINER_NAME)-arm64" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "exited" ]; then \
		printf "${MAGENTA}[WARNING]${RESET}%-1sContainer ${CYAN}$(CONTAINER_NAME)-arm64${RESET} is ${MAGENTA}exited${RESET}. ${YELLOW}Restarting...${RESET}\n"; \
	fi;
	@docker start $(CONTAINER_NAME)-arm64 >> /dev/null; \
		printf "[INFO]%-4sContainer ${CYAN}$(CONTAINER_NAME)-arm64${RESET} is ${GREEN}running${RESET}.\n";
	@docker exec -it $(CONTAINER_NAME)-arm64 bash
else
	@printf "${RED}[ERROR]${RESET}:%-2sUnknown architecture: ${MAGENTA}$(LOWER_ARCH)${RESET}\n";
endif

.PHONY: halt
halt: ## Stop the running container
ifeq ($(LOWER_ARCH), x86_64)
	@CONTAINER_STATUS=$(shell docker ps -a --filter "name=$(CONTAINER_NAME)-amd64" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "running" ]; then \
		printf "[INFO]%-4sContainer ${CYAN}$(CONTAINER_NAME)-amd64${RESET} is ${GREEN}running${RESET}.\n"; \
	fi;
	@docker stop $(CONTAINER_NAME)-amd64 >> /dev/null; \
		printf "[INFO]%-4sContainer ${CYAN}$(CONTAINER_NAME)-amd64${RESET} is ${GREEN}exited${RESET}.\n";
else ifeq ($(LOWER_ARCH), arm64)
	@CONTAINER_STATUS=$(shell docker ps -a --filter "name=$(CONTAINER_NAME)-arm64" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "running" ]; then \
		printf "[INFO]%-4sStop Container ${CYAN}$(CONTAINER_NAME)-arm64${RESET}.\n"; \
	fi;
	@docker stop $(CONTAINER_NAME)-arm64 >> /dev/null; \
		printf "[INFO]%-4sContainer ${CYAN}$(CONTAINER_NAME)-arm64${RESET} is ${GREEN}exited${RESET}.\n";
else
	@printf "${RED}[ERROR]${RESET}:%-2sUnknown architecture: ${MAGENTA}$(LOWER_ARCH)${RESET}\n";
endif

.PHONY: clean
clean: ## Garbage disposal
	@if [ ! -z $(CONTAINER_IMAGES_PURGE) ]; then \
		docker rmi -f $(CONTAINER_IMAGES_PURGE); \
	fi
	@if [ ! -z $(CONTAINER_CLEAN) ]; then \
		docker rm -f $(CONTAINER_CLEAN); \
	fi

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n${YELLOW}Usage:${RESET}\n  make ${CYAN}<target>${RESET}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${CYAN}%-15s${RESET} %s\n", $$1, $$2 } /^##@/ { printf "\n${YELLOW}%s${RESET}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
