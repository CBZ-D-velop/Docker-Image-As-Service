# FROM dind
FROM docker@sha256:826fc608d01af1f6fba86ee2df8332d10d7c0a3361d95a02dbd20d2c122496c8

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_WORKDIR=""
ARG DOCKER_TIMEOUT=""
ARG DOCKER_SCOUT_VERION=""

ENV ENV_MAINTAINER="${MAINTAINER}"
ENV ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}"

ENV ENV_DEFAULT_USER="${DEFAULT_USER}"
ENV ENV_DEFAULT_GROUP="${DEFAULT_GROUP}"
ENV ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}"
ENV ENV_VERSION="${VERSION}"
ENV ENV_DOCKER_TIMEOUT="${DOCKER_TIMEOUT}"
ENV ENV_DOCKER_SCOUT_VERION="${DOCKER_SCOUT_VERION}"

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

# Install Docker scout
RUN apk add --no-cache --update curl wget tar && \
    wget "https://github.com/docker/scout-cli/releases/download/v${ENV_DOCKER_SCOUT_VERION}/docker-scout_${ENV_DOCKER_SCOUT_VERION}_linux_amd64.tar.gz" --secure-protocol=TLSv1_2 --max-redirect=1 -q && \
    mkdir -p ~/.docker/cli-plugins && \
    tar xvzf ./*.tar.gz && mv docker-scout ~/.docker/cli-plugins/. && \
    chmod +x ~/.docker/cli-plugins/docker-scout && \
    docker scout --help

# Remove packages cache
RUN rm -rf /var/cache/apk/* ~/.cache/*

# Increase default docker timeout
ENV DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_TIMEOUT}
ENV COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_TIMEOUT}

RUN export DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_TIMEOUT} && \
    export COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_TIMEOUT}

# Set CMD
USER "${DEFAULT_USER}":"${DEFAULT_GROUP}"
CMD ["docker", "scout", "--help"]
