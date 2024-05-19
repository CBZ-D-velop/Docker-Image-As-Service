# FROM 3.18
FROM alpine@sha256:48d9183eb12a05c99bcc0bf44a003607b8e941e1d4f41f9ad12bdcc4b5672f86

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_USER_ID=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_GROUP_GID=""
ARG DEFAULT_USER_HOME=""
ARG DEFAULT_WORKDIR=""

ENV VERSION="${VERSION}" \
    ENV_MAINTAINER="${MAINTAINER}" \
    ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}" \
    ENV_DEFAULT_USER="${DEFAULT_USER}" \
    ENV_DEFAULT_USER_ID="${DEFAULT_USER_ID}" \
    ENV_DEFAULT_GROUP="${DEFAULT_GROUP}" \
    ENV_DEFAULT_GROUP_GID="${DEFAULT_GROUP_GID}" \
    ENV_DEFAULT_USER_HOME="${DEFAULT_USER_HOME}" \
    ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}"

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
    rsync curl git gnupg openssh \
    sudo openssl zip bzip2 tar unzip gpg && \
    rm -rf /var/cache/apk/*

#
# Actions as root
#

# Install python and pip
RUN apk add --update --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir --break-system-packages --upgrade pip setuptools && \
    python3 --version

# Install Ansible, Molecule, comunity additions
WORKDIR "${HOME}"
COPY --chown="root:root" ./requirements.txt ./requirements.txt
RUN python3 -m pip install --no-cache-dir -r ./requirements.txt --break-system-packages && \
    export PATH="/$HOME/.local/bin:${PATH}"

#
# Actions as user
#

USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"

# Checks & CMD
RUN yamllint --version
CMD ["/bin/bash"]
