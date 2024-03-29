# FROM 3.18
FROM alpine@sha256:48d9183eb12a05c99bcc0bf44a003607b8e941e1d4f41f9ad12bdcc4b5672f86

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_WORKDIR=""

ENV ENV_MAINTAINER="${MAINTAINER}"
ENV ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}"

ENV ENV_DEFAULT_USER="${DEFAULT_USER}"
ENV ENV_DEFAULT_GROUP="${DEFAULT_GROUP}"
ENV ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}"
ENV ENV_VERSION="${VERSION}"

LABEL "version"="${ENV_VERSION}"
LABEL "maintainer"="${ENV_MAINTAINER} <${ENV_MAINTAINER_ADDRESS}>"
LABEL "maintainer-address"="${ENV_MAINTAINER_ADDRESS}"

# Check if the user exists, and create it if not
RUN if ! id -u ${ENV_DEFAULT_USER} > /dev/null 2>&1; then \
        adduser -D ${ENV_DEFAULT_USER}; \
    fi

# Check if the work directory exists, and create it if not
RUN mkdir -p ${ENV_DEFAULT_WORKDIR}

# Set the working directory
WORKDIR ${ENV_DEFAULT_WORKDIR}

# Update installed packages
RUN apk update && \
    apk add --no-cache make bash gnupg

# Install python and pip
RUN apk add --update --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir --upgrade pip setuptools

# Install ansible-lint
RUN apk add --update --no-cache ansible-lint && \
    ansible-lint --version

# Install basics requirements for Ansible (vault)
RUN apk add --no-cache \
    rsync curl python3 \
    libffi-dev wget lsb-release \
    ca-certificates sudo nano \
    net-tools procps openssl lsof zip \
    tree iftop htop nethogs iproute2 \
    git bzip2 tar unzip py3-pip \
    py3-jmespath py3-lxml py3-pip py3-setuptools

# Isntall Ansible
COPY --chown="${DEFAULT_USER}:${DEFAULT_GROUP}" ./requirements.txt ./requirements.txt
RUN python3 -m pip install --no-cache-dir -r ./requirements.txt --break-system-packages && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install community.docker && \
    ansible --version

# Remove packages cache
RUN apk del build-dependencies; \
    rm -rf /var/cache/apk/* && \
    rm -rf ~/.cache/*

# Set CMD
USER "${DEFAULT_USER}":"${DEFAULT_GROUP}"
CMD ["ansible-lint", "--version"]
