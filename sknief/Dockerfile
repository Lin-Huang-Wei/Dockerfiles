From --platform=linux/amd64 ubuntu:22.04

# Update: 2024-05-17
LABEL maintainer="Daniel Lin"

##############################
# Set locales
##############################

RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

##############################
# Set TimeZone
##############################

ENV TZ=Asia/Taipei
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

##############################
# Install Base Tools
##############################

# Package 'python-pip' has no installation candidate on Ubuntu 20.04, use 'python3-pip' to replace it.
RUN apt-get update -y  \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    build-essential \
    curl \
    ca-certificates  \
    dnsutils \
    git \
    gettext-base \
    jq \
    iptables \
    net-tools \
    python3-pip \
    rsync \
    supervisor \
    software-properties-common \
    tig \
    tree \
    tmux \
    unzip \
    vim \
    wget \
    zip

##############################
# Install AWS CLI Requirement Packages
##############################

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y groff less

##############################
# Install Azure CLI Requirement Packages
##############################

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

##############################
# Upgrade pip
##############################

RUN pip install --upgrade pip

##############################
# Install Ansible Requirement Software
##############################

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sshpass openssh-client

##############################
# Install AWS Cli v2
##############################

ARG buildtime_AWSCLIv2_VERSION='2.11.6'
ENV AWSCLIv2_VERSION=${buildtime_AWSCLIv2_VERSION}
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${buildtime_AWSCLIv2_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && echo "# AWS CLI autocompletion" >> /root/.bashrc \
    && echo "complete -C '/usr/local/bin/aws_completer' aws" >> /root/.bashrc \
    && echo "" >> /root/.bashrc \
    && rm -rf /awscliv2.zip

##############################
# Install Azure Cli
# apt-cache policy azure-cli
##############################

ARG buildtime_AZ_VERSION='2.55.0'
ENV AZ_VERSION=${buildtime_AZ_VERSION}
RUN mkdir -p /etc/apt/keyrings \
    && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/microsoft.gpg \
    && AZ_DIST=$(lsb_release -cs) \
    && echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ ${AZ_DIST} main" |  \
    tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update -y  \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y azure-cli=${AZ_VERSION}-1~${AZ_DIST}

##############################
# Install Terraform
##############################

ARG buildtime_TF_VERSION=' 1.4.6'
ENV TF_VERSION=${buildtime_TF_VERSION}
RUN curl -s "https://releases.hashicorp.com/terraform/${buildtime_TF_VERSION}/terraform_${buildtime_TF_VERSION}_linux_amd64.zip" -o terraform_${buildtime_TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${buildtime_TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    # Reference: https://discuss.hashicorp.com/t/terraform-autocompletion-not-working-on-macos-with-default-zsh-shell/10701/3
    && echo "# Terraform autocompletion" >> /root/.bashrc  \
    && echo "complete -o nospace -C '/usr/local/bin/terraform' terraform" >> /root/.bashrc \
    && echo "" >> /root/.bashrc \
    && rm -rf /terraform_${buildtime_TF_VERSION}_linux_amd64.zip

##############################
# Install Ansible
##############################

ARG buildtime_ANSIBLE_VERSION='2.14.5'
ENV ANSIBLE_VERSION=${buildtime_ANSIBLE_VERSION}
RUN pip install ansible-core==${buildtime_ANSIBLE_VERSION} && \
    pip install ansible-lint

##############################
# Install Kubectl
# Reference: https://kubernetes.io/releases/
##############################

ARG buildtime_KUBECTL_VERSION='1.27.1'
ENV KUBECTL_VERSION=${buildtime_KUBECTL_VERSION}
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && mv /kubectl /usr/local/bin/ \
    && chmod +x /usr/local/bin/kubectl \
    && echo "# Kubectl auto-completion and aliases" >> /root/.bashrc \
    && echo "source <(kubectl completion bash)" >> /root/.bashrc \
    && echo "alias k=kubectl" >> /root/.bashrc \
    && echo "complete -F __start_kubectl k" >> /root/.bashrc \
    && echo ". /usr/share/bash-completion/bash_completion" >> /root/.bashrc \
    && echo "" >> /root/.bashrc

##############################
# Install Krew
##############################

ARG buildtime_KREW_VERSION='0.4.4'
ENV KREW_VERSION=${buildtime_KREW_VERSION}
RUN curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_amd64.tar.gz" \
    && tar -zxvf krew-linux_amd64.tar.gz ./krew-linux_amd64 \
    && ./krew-linux_amd64 install krew \
    && rm -rf ./krew-linux_amd64 \
    && echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> /root/.bashrc

##############################
# Install Helm
##############################

ARG buildtime_HELM_VERSION='3.11.3'
ENV HELM_VERSION=${buildtime_HELM_VERSION}
RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && mv ./linux-amd64/helm /usr/local/bin/ \
    && chmod +x /usr/local/bin/helm \
    && rm -rf linux_amd64 helm-v${HELM_VERSION}-linux-amd64.tar.gz

##############################
# Install Tekton
##############################

ARG buildtime_TEKTON_VERSION='0.30.1'
ENV TEKTON_VERSION=${buildtime_TEKTON_VERSION}
RUN curl -LO https://github.com/tektoncd/cli/releases/download/v${TEKTON_VERSION}/tkn_${TEKTON_VERSION}_Linux_x86_64.tar.gz \
    && tar -zxvf tkn_${TEKTON_VERSION}_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn \
    && chmod +x /usr/local/bin/tkn \
    && rm -rf /tkn_${TEKTON_VERSION}_Linux_x86_64.tar.gz

##############################
# Install Go
##############################

ARG buildtime_GOLANG_VERSION='1.20.3'
ENV GOLANG_VERSION=${buildtime_GOLANG_VERSION}
RUN curl -LO https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz

##############################
# Install K9S
##############################

ARG buildtime_K9S_VERSION='0.27.4'
ENV K9S_VERSION=${buildtime_K9S_VERSION}

RUN curl -LO https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_amd64.tar.gz \
    && tar -zxvf k9s_Linux_amd64.tar.gz -C /usr/local/bin k9s \
    && chmod +x /usr/local/bin/k9s \
    && rm -rf k9s_Linux_amd64.tar.gz

##############################
# Install yq
##############################

ARG buildtime_YQ_VERSION='4.35.2'
ENV YQ_VERSION=${buildtime_YQ_VERSION}

RUN curl -LO https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64  \
    && mv yq_linux_amd64 /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

##############################
# Install Neovim
##############################

ARG buildtime_NEOVIM_VERSION='0.9.2'
ENV NEOVIM_VERSION=${buildtime_NEOVIM_VERSION}

RUN curl -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz \
    && tar -zxvf nvim-linux64.tar.gz -C /opt \
    && ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/vim \
    && rm -rf nvim-linux64.tar.gz

##############################
# Install Docker
# Reference: https://github.com/cruizba/ubuntu-dind/tree/master
##############################

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=24.0.7 \
    DOCKER_COMPOSE_VERSION=v2.23.0 \
    BUILDX_VERSION=v0.11.2 \
    DEBUG=false

# Docker and buildx installation
RUN set -eux; \
	\
	arch="$(uname -m)"; \
	case "$arch" in \
        # amd64
		x86_64) dockerArch='x86_64' ; buildx_arch='linux-amd64' ;; \
    *) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;;\
	esac; \
	\
	if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
		echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
		exit 1; \
	fi; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	if ! wget -O docker-buildx "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.${buildx_arch}"; then \
		echo >&2 "error: failed to download 'buildx-${BUILDX_VERSION}.${buildx_arch}'"; \
		exit 1; \
	fi; \
	mkdir -p /usr/local/lib/docker/cli-plugins; \
	chmod +x docker-buildx; \
	mv docker-buildx /usr/local/lib/docker/cli-plugins/docker-buildx; \
	\
	dockerd --version; \
	docker --version; \
	docker buildx version; \
  \
  test ! -d /opt/bash-utils && echo 'mkdir -p /opt/bash-utils'

COPY modprobe start-docker.sh entrypoint.sh /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY logger.sh /opt/bash-utils/logger.sh

RUN chmod +x /usr/local/bin/start-docker.sh \
	/usr/local/bin/entrypoint.sh \
	/usr/local/bin/modprobe

VOLUME /var/lib/docker

# Docker compose installation
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose && docker-compose version

# Create a symlink to the docker binary in /usr/local/lib/docker/cli-plugins
# for users which uses 'docker compose' instead of 'docker-compose'
RUN ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

##############################
# Install gum
# Reference: https://github.com/charmbracelet/gum
##############################

ARG buildtime_GUM_VERSION='0.13.0'
ENV GUM_VERSION=${buildtime_GUM_VERSION}

RUN curl -LO https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_Linux_x86_64.tar.gz \
    && tar -zxvf gum_${GUM_VERSION}_Linux_x86_64.tar.gz -C /usr/local/bin gum \
    && chmod +x /usr/local/bin/gum \
    && rm -rf gum_${GUM_VERSION}_Linux_x86_64.tar.gz

##############################
# Create Work Directory
##############################

ENV AWS_CONFIG_FILE=/work/.aws/config
ENV AWS_SHARED_CREDENTIALS_FILE=/work/.aws/credentials
RUN mkdir -p /work/.aws /work/terraform /work/ansible /work/tekton /root/.terraform.d/plugins

##############################
# Clean apt-get cache
##############################

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

ENV PATH /usr/local/go/bin:${PATH}
ENV TERM=xterm-256color

EXPOSE 22
VOLUME ["/work/"]
WORKDIR /work
ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]
