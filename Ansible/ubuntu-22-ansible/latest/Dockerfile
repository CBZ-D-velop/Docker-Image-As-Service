# FROM 11
FROM ubuntu@sha256:81bba8d1dde7fc1883b6e95cd46d6c9f4874374f2b360c8db82620b33f6b5ca1

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
        useradd -m ${ENV_DEFAULT_USER}; \
    fi

# Check if the work directory exists, and create it if not
RUN mkdir -p ${ENV_DEFAULT_WORKDIR}

# Set the working directory
WORKDIR ${ENV_DEFAULT_WORKDIR}

# Update the host, fix upgrade
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-get update && apt-get upgrade -y

# Install basics requirements
RUN apt-get install --no-install-recommends -y \
    rsync curl python3 python3-jmespath python3-pip \
    python3-lxml libssl-dev libffi-dev git wget \
    lsb-release gnupg2 software-properties-common \
    apt-transport-https ca-certificates sudo nano \
    net-tools procps openssl lsof zip \
    tree python3-apt python3-pip python3-setuptools \
    iftop htop cron virtualenv nethogs iproute2 \
    git init bzip2 tar unzip locales iptables-persistent

# CLear all apt files
RUN apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y && \
    apt-get autoremove --purge -y && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN python3 -m pip install --no-cache-dir requests passlib

# Set CMD
USER "${DEFAULT_USER}":"${DEFAULT_GROUP}"
CMD ["sbin/init"]
