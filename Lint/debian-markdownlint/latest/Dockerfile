# FROM 20.11.1-slim
FROM node@sha256:899cee7d447d02c1c8590eef0b57eb6c1dec10e9c1cce7942aa7a7e3d5c0e842

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

# Update the host, fix upgrade
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-mark hold debian-archive-keyring && apt-get update && apt-get upgrade -y && \
    apt-get upgrade debian-archive-keyring -y --allow-change-held-packages

# Install markdown lint
RUN npm i --ignore-scripts -g markdownlint-cli

# CLear all apt files
RUN apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y && \
    apt-get autoremove --purge -y && rm -rf /var/lib/apt/lists/*

# Set CMD
USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"
CMD ["markdownlint", "-v"]
