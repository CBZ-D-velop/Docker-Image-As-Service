# FROM 3.18
FROM alpine@sha256:48d9183eb12a05c99bcc0bf44a003607b8e941e1d4f41f9ad12bdcc4b5672f86

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_WORKDIR=""

ENV ENV_MAINTAINER="${MAINTAINER}" \
    ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}" \
    ENV_DEFAULT_USER="${DEFAULT_USER}" \
    ENV_DEFAULT_GROUP="${DEFAULT_GROUP}" \
    ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}" \
    ENV_VERSION="${VERSION}"

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
RUN apk update && \
    apk add --no-cache make bash

# Install python and pip
RUN apk add --update --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir --upgrade pip setuptools

# Install j2lint
RUN pip3 install --no-cache-dir j2lint && \
    j2lint --version

# Remove packages cache
RUN apk del build-dependencies; \
    rm -rf /var/cache/apk/* && \
    rm -rf ~/.cache/*

# Set CMD
USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"
CMD ["j2lint", "--version"]
