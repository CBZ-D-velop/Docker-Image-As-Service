# FROM dind
FROM docker@sha256:826fc608d01af1f6fba86ee2df8332d10d7c0a3361d95a02dbd20d2c122496c8

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_WORKDIR=""
ARG DOCKER_TIMEOUT=""

ENV ENV_MAINTAINER="${MAINTAINER}" \
    ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}" \
    ENV_DEFAULT_USER="${DEFAULT_USER}" \
    ENV_DEFAULT_GROUP="${DEFAULT_GROUP}" \
    ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}" \
    ENV_VERSION="${VERSION}" \
    ENV_DOCKER_TIMEOUT="${DOCKER_TIMEOUT}"

LABEL   "version"="${ENV_VERSION}"  \
        "maintainer"="${ENV_MAINTAINER} <${ENV_MAINTAINER_ADDRESS}>"

# Check if the user exists, and create it if not, add workdir
RUN if ! id -u "${ENV_DEFAULT_GROUP}" > /dev/null 2>&1; then \
        addgroup -g "${ENV_DEFAULT_USER_GID}" "${ENV_DEFAULT_GROUP}"; \
    fi && \
    if ! id -u "${ENV_DEFAULT_USER}" > /dev/null 2>&1; then \
        adduser -u "${ENV_DEFAULT_USER_ID}" -G "${ENV_DEFAULT_GROUP}" -D \
        -h "${ENV_DEFAULT_WORKDIR}" "${ENV_DEFAULT_USER}" -s /bin/bash; \
    fi

# Update installed packages
# Start and enable docker
RUN apk update && \
    apk add --no-cache make openrc docker git tar unzip bzip2 bash && \
    rc-update add docker boot

# Remove packages cache
RUN rm -rf /var/cache/apk/* ~/.cache/*

# Increase default docker timeout
ENV DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_TIMEOUT} \
    COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_TIMEOUT}
RUN echo '#!/bin/sh' > /usr/local/bin/entrypoint.sh && \
    echo "export DOCKER_CLIENT_TIMEOUT=${ENV_DOCKER_TIMEOUT}" >> /usr/local/bin/entrypoint.sh && \
    echo "export COMPOSE_HTTP_TIMEOUT=${ENV_DOCKER_TIMEOUT}" >> /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    /usr/local/bin/entrypoint.sh

# Set CMD
USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"
CMD ["/usr/local/bin/entrypoint.sh"]
