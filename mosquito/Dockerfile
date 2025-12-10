FROM ubuntu:24.04

# Update: 2025-01-07
LABEL maintainer="Daniel Lin"

##############################
# Set to build the specific platform
# Reference: https://docs.docker.com/reference/dockerfile/#automatic-platform-args-in-the-global-scope
##############################
ARG TARGETPLATFORM
RUN echo "Start building for ${TARGETPLATFORM}"

##############################
# Set locales
##############################

RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

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
    apt-transport-https \
    bash \
    bash-completion \
    build-essential \
    curl \
    ca-certificates  \
    dnsutils \
    git \
    gnupg \
    gettext-base \
    jq \
    iptables \
    net-tools \
    neovim \
    python3-pip \
    pwgen \
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

# ##############################
# # Install Python 3.11
# ##############################

# RUN gpg --keyserver keyserver.ubuntu.com --recv-keys BA6932366A755776 \
#     && gpg --export --armor BA6932366A755776 | tee /etc/apt/keyrings/ba6932366a755776.asc \
#     && echo "deb [signed-by=/etc/apt/keyrings/ba6932366a755776.asc] https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/python3-ppa:deadsnakes.list \
#     && echo "deb-src [signed-by=/etc/apt/keyrings/ba6932366a755776.asc] https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/python3-ppa:deadsnakes.list \
#     && apt-get update -y \
#     && DEBIAN_FRONTEND=noninteractive apt-get install -y python3.11

##############################
# Upgrade pip
##############################

# # 設置環境變量，防止 Python 生成 .pyc 文件
# ENV PYTHONDONTWRITEBYTECODE=1
# # 確保輸出立即顯示，而不是被緩衝
# ENV PYTHONUNBUFFERED=1
# RUN pip install --upgrade pip

##############################
# Install Ansible Requirement Software
##############################

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sshpass openssh-client

##############################
# Install Ansible
##############################

ARG buildtime_ANSIBLE_VERSION='2.17.0'
ENV ANSIBLE_VERSION=${buildtime_ANSIBLE_VERSION}
RUN pip install ansible-core==${ANSIBLE_VERSION} --break-system-packages && \
    pip install ansible-lint --break-system-packages && \
    pip install molecule --break-system-packages

##############################
# Install Docker
##############################

ARG buildtime_DOCKER_VERSION='24.0.7' \
    buildtime_DOCKER_COMPOSE_VERSION='2.24.0' \
    buildtime_BUILDX_VERSION='0.11.2'
ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=${buildtime_DOCKER_VERSION} \
    DOCKER_COMPOSE_VERSION=${buildtime_DOCKER_COMPOSE_VERSION} \
    BUILDX_VERSION=${buildtime_BUILDX_VERSION}
RUN set -eux; \
    arch="$(uname -m)"; \
    case "$arch" in \
        x86_64) dockerArch='x86_64' ; buildx_arch='linux-amd64' ;; \
        armhf) dockerArch='armel' ; buildx_arch='linux-arm-v6' ;; \
        armv7) dockerArch='armhf' ; buildx_arch='linux-arm-v7' ;; \
        aarch64) dockerArch='aarch64' ; buildx_arch='linux-arm64' ;; \
        *) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;; \
    esac && \
    wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz" && \
    tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ && \
    rm docker.tgz && \
    wget -O docker-buildx "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.${buildx_arch}" && \
    mkdir -p /usr/local/lib/docker/cli-plugins && \
    chmod +x docker-buildx && \
    mv docker-buildx /usr/local/lib/docker/cli-plugins/docker-buildx && \
    dockerd --version && \
    docker --version && \
    docker buildx version

COPY container-utility/modprobe \
      container-utility/start-docker.sh \
      container-utility/entrypoint.sh \
      /usr/local/bin/
COPY container-utility/supervisor/ /etc/supervisor/conf.d/
COPY container-utility/logger.sh /opt/bash-utils/logger.sh

RUN chmod +x /usr/local/bin/start-docker.sh \
    /usr/local/bin/entrypoint.sh \
    /usr/local/bin/modprobe

VOLUME /var/lib/docker

# Install Docker Compose
RUN set -eux; \
    curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose version && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

##############################
# Install AWS Cli v2
##############################

ARG buildtime_AWSCLIv2_VERSION='2.15.6'
ENV AWSCLIv2_VERSION=${buildtime_AWSCLIv2_VERSION}
RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    case "${LOWER_ARCH}" in \
      amd64) curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${buildtime_AWSCLIv2_VERSION}.zip" -o "awscliv2.zip" ;;  \
      arm64) curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64-${buildtime_AWSCLIv2_VERSION}.zip" -o "awscliv2.zip" ;; \
      *) echo >&2 "Unsupported architecture: $LOWER_ARCH"; exit 1; \
    esac; \
    unzip awscliv2.zip \
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
    && apt-get update -y || true \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y azure-cli=${AZ_VERSION}-1~${AZ_DIST}

##############################
# Install GCP
# apt-cache policy google-cloud-cli
# Reference: https://cloud.google.com/sdk/docs/release-notes
##############################

ARG buildtime_GCPCLI_VERSION='504.0.1-0'
ENV GCPCLI_VERSION=${buildtime_GCPCLI_VERSION}
RUN curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get update -y \
    && apt-get install -y google-cloud-cli=${GCPCLI_VERSION} \
    && echo "# GCP autocompletion" >> /root/.bashrc  \
    && echo "source $(gcloud info --format='value(installation.sdk_root)')/completion.bash.inc" >> /root/.bashrc

##############################
# Install docker-credential-gcr for a Docker credential helper for GCR user
# Reference: https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases
##############################

ARG buildtime_DOCKER_CREDENTIAL_GCR_VERSION='2.1.25'
ENV DOCKER_CREDENTIAL_GCR_VERSION=${buildtime_DOCKER_CREDENTIAL_GCR_VERSION}
RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    curl -LO "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${DOCKER_CREDENTIAL_GCR_VERSION}/docker-credential-gcr_linux_${LOWER_ARCH}-${DOCKER_CREDENTIAL_GCR_VERSION}.tar.gz" \
    && tar -zxvf docker-credential-gcr_linux_${LOWER_ARCH}-${DOCKER_CREDENTIAL_GCR_VERSION}.tar.gz -C /usr/local/bin/ docker-credential-gcr \
    && rm -rf docker-credential-gcr_linux_${LOWER_ARCH}-${DOCKER_CREDENTIAL_GCR_VERSION}.tar.gz

##############################
# Install Terraform
##############################

ARG buildtime_TF_VERSION='1.4.6'
ENV TF_VERSION=${buildtime_TF_VERSION}
RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    curl -s "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${LOWER_ARCH}.zip" -o terraform_${TF_VERSION}_linux_${LOWER_ARCH}.zip \
    && unzip terraform_${TF_VERSION}_linux_${LOWER_ARCH}.zip \
    && mv terraform /usr/local/bin/ \
    # Reference: https://discuss.hashicorp.com/t/terraform-autocompletion-not-working-on-macos-with-default-zsh-shell/10701/3
    && echo "# Terraform autocompletion" >> /root/.bashrc  \
    && echo "complete -o nospace -C '/usr/local/bin/terraform' terraform" >> /root/.bashrc \
    && echo "" >> /root/.bashrc \
    && rm -rf /terraform_${TF_VERSION}_linux_${LOWER_ARCH}.zip

##############################
# Install Kubectl
# Reference: https://kubernetes.io/releases/
##############################

ARG buildtime_KUBECTL_VERSION='1.28.5'
ENV KUBECTL_VERSION=${buildtime_KUBECTL_VERSION}
RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${LOWER_ARCH}/kubectl" \
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
RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_${LOWER_ARCH}.tar.gz" \
    && tar -zxvf krew-linux_${LOWER_ARCH}.tar.gz ./krew-linux_${LOWER_ARCH} \
    && ./krew-linux_${LOWER_ARCH} install krew \
    && rm -rf ./krew-linux_${LOWER_ARCH} ./krew-linux_${LOWER_ARCH}.tar.gz \
    && echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> /root/.bashrc

##############################
# Install kustomize
# https://github.com/kubernetes-sigs/kustomize/releases
##############################

ARG buildtime_KUSTOMIZE_VERSION='5.6.0'
ENV KUSTOMIZE_VERSION=${buildtime_KUSTOMIZE_VERSION}
RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    case "${LOWER_ARCH}" in \
    amd64) \
      curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
      && tar -zxvf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -C /usr/local/bin/ kustomize \
      && chmod +x /usr/local/bin/kustomize \
      && rm -rf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz; \
    ;; \
    arm64) \
      curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_arm64.tar.gz \
      && tar -zxvf kustomize_v${KUSTOMIZE_VERSION}_linux_arm64.tar.gz -C /usr/local/bin/ kustomize \
      && chmod +x /usr/local/bin/kustomize \
      && rm -rf kustomize_v${KUSTOMIZE_VERSION}_linux_arm64.tar.gz; \
    ;; \
    *) echo >&2 "Unsupported architecture: $LOWER_ARCH"; exit 1; \
    esac

##############################
# Install Helm
##############################

ARG buildtime_HELM_VERSION='3.13.3'
ENV HELM_VERSION=${buildtime_HELM_VERSION}
RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${LOWER_ARCH}.tar.gz" \
    && tar -zxvf helm-v${HELM_VERSION}-linux-${LOWER_ARCH}.tar.gz \
    && mv ./linux-${LOWER_ARCH}/helm /usr/local/bin/ \
    && chmod +x /usr/local/bin/helm \
    && rm -rf linux_${LOWER_ARCH} helm-v${HELM_VERSION}-linux-${LOWER_ARCH}.tar.gz

##############################
# Install Tekton
##############################

ARG buildtime_TEKTON_VERSION='0.33.0'
ENV TEKTON_VERSION=${buildtime_TEKTON_VERSION}
RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    case "${LOWER_ARCH}" in \
    amd64) \
      curl -LO https://github.com/tektoncd/cli/releases/download/v${TEKTON_VERSION}/tkn_${TEKTON_VERSION}_Linux_x86_64.tar.gz \
      && tar -zxvf tkn_${buildtime_TEKTON_VERSION}_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn \
      && chmod +x /usr/local/bin/tkn \
      && rm -rf /tkn_${buildtime_TEKTON_VERSION}_Linux_x86_64.tar.gz; \
    ;; \
    arm64) \
      curl -LO https://github.com/tektoncd/cli/releases/download/v${TEKTON_VERSION}/tkn_${TEKTON_VERSION}_Linux_aarch64.tar.gz \
      && tar -zxvf tkn_${buildtime_TEKTON_VERSION}_Linux_aarch64.tar.gz -C /usr/local/bin/ tkn \
      && chmod +x /usr/local/bin/tkn \
      && rm -rf /tkn_${buildtime_TEKTON_VERSION}_Linux_aarch64.tar.gz; \
    ;; \
    *) echo >&2 "Unsupported architecture: $LOWER_ARCH"; exit 1; \
    esac

##############################
# Install Go
##############################

ARG buildtime_GOLANG_VERSION='1.20.3'
ENV GOLANG_VERSION=${buildtime_GOLANG_VERSION}

RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    curl -LO https://go.dev/dl/go${GOLANG_VERSION}.linux-${LOWER_ARCH}.tar.gz \
    && tar -zxvf go${GOLANG_VERSION}.linux-${LOWER_ARCH}.tar.gz -C /usr/local/ \
    && rm -rf go${GOLANG_VERSION}.linux-${LOWER_ARCH}.tar.gz

##############################
# Install K9S
##############################

ARG buildtime_K9S_VERSION='0.31.5'
ENV K9S_VERSION=${buildtime_K9S_VERSION}

RUN set -eux; \
    LOWER_ARCH="$(dpkg --print-architecture)"; \
    curl -fsSLO "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${LOWER_ARCH}.tar.gz" \
    && tar -zxvf k9s_Linux_${LOWER_ARCH}.tar.gz -C /usr/local/bin/ k9s \
    && chmod +x /usr/local/bin/k9s \
    && rm -f k9s_Linux_${LOWER_ARCH}.tar.gz

##############################
# Install Loki CLI
##############################

ARG buildtime_LOKI_VERSION='2.8.7'
ENV LOKI_VERSION=${buildtime_LOKI_VERSION}

RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    curl -LO https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/logcli-linux-${LOWER_ARCH}.zip \
    && unzip logcli-linux-${LOWER_ARCH}.zip \
    && mv logcli-linux-${LOWER_ARCH} /usr/local/bin/logcli \
    && chmod +x /usr/local/bin/logcli \
    && echo "" >> /root/.bashrc \
    && echo "# LOKI CLI autocompletion" >> /root/.bashrc \
    && echo 'eval "$(logcli --completion-script-bash)"' >> /root/.bashrc \
    && rm -rf logcli-linux-${LOWER_ARCH}.zip

##############################
# Install yq
##############################

ARG buildtime_YQ_VERSION='4.40.5'
ENV YQ_VERSION=${buildtime_YQ_VERSION}

RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    curl -LO https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${LOWER_ARCH}  \
    && mv yq_linux_${LOWER_ARCH} /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

##############################
# Install gum
# Reference: https://github.com/charmbracelet/gum
##############################

ARG buildtime_GUM_VERSION='0.13.0'
ENV GUM_VERSION=${buildtime_GUM_VERSION}

RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    case "${LOWER_ARCH}" in \
    amd64) \
      curl -LO https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_Linux_x86_64.tar.gz \
      && tar -zxvf gum_${GUM_VERSION}_Linux_x86_64.tar.gz --strip-components=1 -C /usr/local/bin gum_${GUM_VERSION}_Linux_x86_64/gum \
      && chmod +x /usr/local/bin/gum \
      && rm -rf gum_${GUM_VERSION}_Linux_x86_64.tar.gz; \
    ;; \
    arm64) \
      curl -LO https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_Linux_arm64.tar.gz \
      && tar -zxvf gum_${GUM_VERSION}_Linux_arm64.tar.gz --strip-components=1 -C /usr/local/bin gum_${GUM_VERSION}_Linux_arm64/gum \
      && chmod +x /usr/local/bin/gum \
      && rm -rf gum_${GUM_VERSION}_Linux_arm64.tar.gz; \
    ;; \
    *) echo >&2 "Unsupported architecture: $LOWER_ARCH"; exit 1; \
    esac

##############################
# Install infracost
# Reference: https://github.com/infracost/infracost/releases
##############################

ARG buildtime_INFRACOST_VERSION='0.10.41'
ENV INFRACOST_VERSION=${buildtime_INFRACOST_VERSION}

RUN set -eux; \
    LOWER_ARCH=$(dpkg --print-architecture); \
    case "${LOWER_ARCH}" in \
    amd64) \
      curl -LO https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-${LOWER_ARCH}.tar.gz \
      && tar -zxvf infracost-linux-${LOWER_ARCH}.tar.gz \
      && mv infracost-linux-${LOWER_ARCH} /usr/local/bin/infracost \
      && chmod +x /usr/local/bin/infracost \
      && rm -rf infracost-linux-${LOWER_ARCH}.tar.gz; \
    ;; \
    arm64) \
      curl -LO https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-${LOWER_ARCH}.tar.gz \
      && tar -zxvf infracost-linux-${LOWER_ARCH}.tar.gz \
      && mv infracost-linux-${LOWER_ARCH} /usr/local/bin/infracost \
      && chmod +x /usr/local/bin/infracost \
      && rm -rf infracost-linux-${LOWER_ARCH}.tar.gz; \
    ;; \
    *) echo >&2 "Unsupported architecture: $LOWER_ARCH"; exit 1; \
    esac

# ##############################
# # Install Neovim
# # Reference: https://gitlab.b-data.ch/neovim/neovim/-/releases
# ##############################

# ARG buildtime_NEOVIM_VERSION='0.9.5'
# ENV NEOVIM_VERSION=${buildtime_NEOVIM_VERSION}

# RUN set -eux; \
#     LOWER_ARCH=$(dpkg --print-architecture); \
#     case "${LOWER_ARCH}" in \
#     amd64) \
#       curl -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz \
#       && tar -zxvf nvim-linux64.tar.gz -C /opt \
#       && ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/vim \
#       && rm -rf nvim-linux64.tar.gz; \
#     ;; \
#     arm64) \
#       curl -LO https://gitlab.b-data.ch/neovim/neovim/-/releases/v${NEOVIM_VERSION}/downloads/builds/nvim-linux-arm64.tar.gz \
#       && tar -zxvf nvim-linux-arm64.tar.gz -C /opt \
#       && ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/vim \
#       && rm -rf nvim-linux-arm64.tar.gz; \
#     ;; \
#     *) echo >&2 "Unsupported architecture: $LOWER_ARCH"; exit 1; \
#     esac

##############################
# Create Work Directory
##############################

RUN mkdir -p /work/terraform /work/ansible /work/tekton /root/.terraform.d/plugins /usr/share/ansible/collections /root/.config/gcloud

##############################
# Setup make auto completion
##############################

COPY container-utility/make_completion.sh /etc/bash_completion.d/make_completion.sh

##############################
# Install required plugins for GKE
# https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#apt_1
##############################

RUN apt-get update -y  \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y google-cloud-cli-gke-gcloud-auth-plugin

##############################
# Clean apt-get cache
##############################

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

ENV TERM=xterm-256color

VOLUME ["/work/"]
WORKDIR /work
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]
