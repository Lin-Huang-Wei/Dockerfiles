From --platform=linux/amd64 ubuntu:24.04

# Update: 2024-05-09
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
# Install Neovim
##############################

ARG buildtime_NEOVIM_VERSION='0.9.5'
ENV NEOVIM_VERSION=${buildtime_NEOVIM_VERSION}

RUN curl -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz \
    && tar -zxvf nvim-linux64.tar.gz -C /opt \
    && ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/vim \
    && rm -rf nvim-linux64.tar.gz

##############################
# Upgrade pip
##############################

RUN pip install --upgrade pip --break-system-packages

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
    pip install ansible-lint --break-system-packages

##############################
# Install Terraform
##############################

ARG buildtime_TF_VERSION='1.4.6'
ENV TF_VERSION=${buildtime_TF_VERSION}
RUN curl -s "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" -o terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    # Reference: https://discuss.hashicorp.com/t/terraform-autocompletion-not-working-on-macos-with-default-zsh-shell/10701/3
    && echo "# Terraform autocompletion" >> /root/.bashrc  \
    && echo "complete -o nospace -C '/usr/local/bin/terraform' terraform" >> /root/.bashrc \
    && echo "" >> /root/.bashrc \
    && rm -rf /terraform_${TF_VERSION}_linux_amd64.zip

##############################
# Create Work Directory
##############################

RUN mkdir -p /work/terraform /work/ansible /work/tekton /root/.terraform.d/plugins

##############################
# Clean apt-get cache
##############################

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

ENV TERM=xterm-256color

VOLUME ["/work/"]
WORKDIR /work
CMD ["bash"]
