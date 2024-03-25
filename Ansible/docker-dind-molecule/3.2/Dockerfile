# FROM dind
FROM docker@sha256:826fc608d01af1f6fba86ee2df8332d10d7c0a3361d95a02dbd20d2c122496c8

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_WORKDIR=""
ARG DOCKER_TIMEOUT=""

ENV ENV_MAINTAINER="${MAINTAINER}"
ENV ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}"

ENV ENV_DEFAULT_USER="${DEFAULT_USER}"
ENV ENV_DEFAULT_GROUP="${DEFAULT_GROUP}"
ENV ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}"
ENV ENV_VERSION="${VERSION}"
ENV ENV_DOCKER_TIMEOUT="${DOCKER_TIMEOUT}"

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
# Start and enable docker
RUN apk update && \
    apk add --no-cache make openrc docker git tar unzip bzip2 bash && \
    rc-update add docker boot

# Install python and pip
RUN apk add --update --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.old && \
    python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir --break-system-packages --upgrade pip setuptools && \
    python3 --version

# Isntall molecule
# Install comunity additions
COPY --chown="${DEFAULT_USER}:${DEFAULT_GROUP}" ./requirements.txt ./requirements.txt
RUN python3 -m pip install --no-cache-dir -r ./requirements.txt --break-system-packages && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install community.docker && \
    ansible --version && \
    molecule --version

# Remove packages cache
RUN apk del build-dependencies; \
    rm -rf /var/cache/apk/* && \
    rm -rf ~/.cache/*

# Increase default docker timeout
ENV DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_TIMEOUT}
ENV COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_TIMEOUT}

RUN export DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_TIMEOUT} \
    export COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_TIMEOUT} \
    systemctl restart docker

RUN echo '#!/bin/sh' > /usr/local/bin/entrypoint.sh && \
    echo "export DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_TIMEOUT}" >> /usr/local/bin/entrypoint.sh && \
    echo "export COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_TIMEOUT}" >> /usr/local/bin/sentrypoint.sh && \
    echo "systemctl restart docker" >> /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Set CMD
USER "${DEFAULT_USER}":"${DEFAULT_GROUP}"
CMD ["/usr/local/bin/entrypoint.sh"]
