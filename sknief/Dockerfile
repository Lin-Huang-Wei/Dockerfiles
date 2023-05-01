From --platform=linux/amd64 ubuntu:22.04

# Update: 2023-04-30
LABEL maintainer="Daniel Lin"

##############################
# Set locales
##############################

RUN apt-get update \
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
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    curl \
    dnsutils \
    git \
    gettext-base \
    jq \
    net-tools \
    python3-pip \
    rsync \
    software-properties-common \
    tig \
    tree \
    unzip \
    vim \
    wget \
    zip

##############################
# Install AWS CLI Requirement Packages
##############################

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y groff less

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
    && echo "complete -C '/usr/local/bin/aws_completer' aws" >> /root/.bashrc \
    && rm -rf /awscliv2.zip

##############################
# Install Terraform
##############################

ARG buildtime_TF_VERSION=' 1.4.6'
ENV TF_VERSION=${buildtime_TF_VERSION}
RUN curl -s "https://releases.hashicorp.com/terraform/${buildtime_TF_VERSION}/terraform_${buildtime_TF_VERSION}_linux_amd64.zip" -o terraform_${buildtime_TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${buildtime_TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    # Reference: https://discuss.hashicorp.com/t/terraform-autocompletion-not-working-on-macos-with-default-zsh-shell/10701/3
    && echo "complete -o nospace -C '/usr/local/bin/terraform' terraform" >> /root/.bashrc \
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
##############################

ARG buildtime_KUBECTL_VERSION='1.27.1'
ENV KUBECTL_VERSION=${buildtime_KUBECTL_VERSION}
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && mv /kubectl /usr/local/bin/ \
    && chmod +x /usr/local/bin/kubectl

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
RUN curl -LO https://github.com/tektoncd/cli/releases/download/v${buildtime_TEKTON_VERSION}/tkn_${buildtime_TEKTON_VERSION}_Linux_x86_64.tar.gz \
    && tar -zxvf tkn_${buildtime_TEKTON_VERSION}_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn \
    && chmod +x /usr/local/bin/tkn \
    && rm -rf /tkn_${buildtime_TEKTON_VERSION}_Linux_x86_64.tar.gz

##############################
# Install Go
##############################

ARG buildtime_GOLANG_VERSION='1.20.3'
ENV GOLANG_VERSION=${buildtime_GOLANG_VERSION}
RUN curl -LO https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz

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

ENV PATH=/usr/local/go/bin:${PATH}

EXPOSE 22
VOLUME ["/work/"]
WORKDIR /work