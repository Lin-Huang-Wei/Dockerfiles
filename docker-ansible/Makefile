####################################################################################################
#                                                                                                  #
# Maintainer: Daniel Lin                                                                           #
# Date: 2020-04-15                                                                                 #
#                                                                                                  #
####################################################################################################

# Set defaults ANSIBLE_VERSION, if variable have be setting, will be replaced.
ifndef ANSIBLE_VERSION
override ANSIBLE_VERSION=2.8.10
endif

# Get Ansible latest tag from github
ANSIBLE_LATEST=$(shell curl -s "https://api.github.com/repos/ansible/ansible/tags" | grep 'name' | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1 | cut -c 2-)

.PHONY: build
build: ## Build ansible docker image from Dockerfile-ansible, defaults ANSIBLE_VERSION=2.8.10
	@printf "\033[33m==================%-2sBuild Ansible Docker, ANSIBLE_VERSION=$(ANSIBLE_VERSION)%-2s==================\033[0m\n"
	@docker build --build-arg buildtime_ANSIBLE_VERSION=$(ANSIBLE_VERSION) -t daniel/ansible:$(ANSIBLE_VERSION) -f Dockerfile-ansible .

.PHONY: run
run: ## Start runing ansible container, when you exit container, container will be delete, defaults ANSIBLE_VERSION=2.8.10
ifeq ($(ANSIBLE_VERSION),$(ANSIBLE_VERSION))
	@printf "\033[33m===========%-2sStart running Ansible Container - ansible version: $(ANSIBLE_VERSION)%-2s============\033[0m\n"
	@docker run --rm -v "$(shell pwd)/ansible:/work/ansible" -it daniel/ansible:$(ANSIBLE_VERSION) bash
else ifeq ($(ANSIBLE_VERSION), $(ANSIBLE_LATEST))
	@printf "\033[33m============%-2sStart running Ansible Container - ansible version: $(ANSIBLE_LATEST)%-2s============\033[0m\n"
	@docker run --rm -v "$(shell pwd)/ansible:/work/ansible" -it daniel/ansible bash
endif 

.PHONY: tag
tag: ## Tag latest for docker image, defaults ANSIBLE_VERSION=2.8.10
ifeq ($(ANSIBLE_VERSION),$(ANSIBLE_LATEST))
	@printf "\033[32m==============================%-2sTag latest Ansible Docker Image%-2s===============================\033[0m\n"
	@docker tag daniel/ansible:$(ANSIBLE_LATEST) daniel/ansible:latest
else
	@printf "\033[31m=================%-2sInfo: The ANSIBLE_VERSION does not equal $(ANSIBLE_LATEST)%-2s=================\033[0m\n"
endif

.PHONY: show_run
show_run: ## Show container status
	@printf "\033[33m===================================%-2sCheck container status%-2s===================================\033[0m\n"
	@docker ps -a

.PHONY: show_iamges
show_images: ## Show container images
	@printf "\033[33m===================================%-2sShow container images%-2s====================================\033[0m\n"
	@docker images

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
