# FROM dind
FROM docker@sha256:826fc608d01af1f6fba86ee2df8332d10d7c0a3361d95a02dbd20d2c122496c8

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_USER_ID=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_GROUP_GID=""
ARG DEFAULT_USER_HOME=""
ARG DEFAULT_WORKDIR=""
ARG DOCKER_API_TIMEOUT=""
ARG DOCKER_SCOUT_VERION=""

ENV VERSION="${VERSION}" \
    ENV_MAINTAINER="${MAINTAINER}" \
    ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}" \
    ENV_DEFAULT_USER="${DEFAULT_USER}" \
    ENV_DEFAULT_USER_ID="${DEFAULT_USER_ID}" \
    ENV_DEFAULT_GROUP="${DEFAULT_GROUP}" \
    ENV_DEFAULT_GROUP_GID="${DEFAULT_GROUP_GID}" \
    ENV_DEFAULT_USER_HOME="${DEFAULT_USER_HOME}" \
    ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}" \
    ENV_DOCKER_API_TIMEOUT="${DOCKER_API_TIMEOUT}" \
    ENV_DOCKER_SCOUT_VERION="${DOCKER_SCOUT_VERION}"

LABEL   "version"="${ENV_VERSION}"  \
        "maintainer"="${ENV_MAINTAINER} <${ENV_MAINTAINER_ADDRESS}>"

# Check if the user exists, and create it if not, add home
RUN if ! id -u "${ENV_DEFAULT_GROUP}" > /dev/null 2>&1; then \
    addgroup -g "${ENV_DEFAULT_GROUP_GID}" "${ENV_DEFAULT_GROUP}"; \
    fi && \
    if ! id -u "${ENV_DEFAULT_USER}" > /dev/null 2>&1; then \
    adduser -u "${ENV_DEFAULT_USER_ID}" -G "${ENV_DEFAULT_GROUP}" \
    -h "${ENV_DEFAULT_USER_HOME}" -s "/bin/bash" -D "${ENV_DEFAULT_USER}"; \
    fi && \
    mkdir -p ${ENV_DEFAULT_WORKDIR} && chmod 0700 -R ${ENV_DEFAULT_WORKDIR} && chown -R ${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP} ${ENV_DEFAULT_WORKDIR}

# Update the host, fix upgrade
# Install basics requirements, and other packages
RUN apk update && apk add --no-cache \
    rsync curl git gnupg wget \
    sudo openssl zip bzip2 tar unzip gpg && \
    rm -rf /var/cache/apk/*

#
# Actions as root
#

# Install docker requirements, start the daemon
RUN apk add --no-cache make openrc docker bash && \
    rc-update add docker boot && \
    rm -rf /var/cache/apk/*

# Increase default docker timeout
ENV DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_API_TIMEOUT} \
    COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_API_TIMEOUT}

# Add default user to docker group
RUN addgroup "${ENV_DEFAULT_USER}" docker

#
# Actions as user
#

USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"

# Increase default docker timeout
ENV DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_API_TIMEOUT} \
    COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_API_TIMEOUT}

# Install Docker scout
RUN wget "https://github.com/docker/scout-cli/releases/download/v${ENV_DOCKER_SCOUT_VERION}/docker-scout_${ENV_DOCKER_SCOUT_VERION}_linux_amd64.tar.gz" --secure-protocol=TLSv1_2 --max-redirect=1 -q && \
    mkdir -p ~/.docker/cli-plugins && \
    tar xvzf ./*.tar.gz && mv docker-scout ~/.docker/cli-plugins/. && \
    chmod +x ~/.docker/cli-plugins/docker-scout && \
    docker scout --help

# Checks & CMD
RUN docker -v && \
    docker scout -h
CMD ["/bin/bash"]
