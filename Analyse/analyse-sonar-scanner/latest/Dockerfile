ARG NODEJS_VERSION=""
FROM node:${NODEJS_VERSION}-alpine AS NODEJS_BASE

# FROM 5.0
FROM sonarsource/sonar-scanner-cli@sha256:494ecc3b5b1ee1625bd377b3905c4284e4f0cc155cff397805a244dee1c7d575

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
ARG NODEJS_VERSION=""

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
    ENV_NODEJS_VERSION="${NODEJS_VERSION}"

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
    rsync curl git gnupg \
    sudo openssl zip bzip2 tar unzip gpg coreutils ca-certificates && \
    rm -rf /var/cache/apk/*

#
# Actions as root
#

# Install python and pip
RUN apk add --update --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    rm /usr/lib/python3.11/EXTERNALLY-MANAGED || \
    python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir --break-system-packages --upgrade pip setuptools && \
    python3 --version

# Install NodeJS and npm
COPY --from=NODEJS_BASE --chown="root:root" --chmod="0755" /usr/lib /usr/lib
COPY --from=NODEJS_BASE --chown="root:root" --chmod="0755" /usr/local/lib /usr/local/lib
COPY --from=NODEJS_BASE --chown="root:root" --chmod="0755" /usr/local/include /usr/local/include
COPY --from=NODEJS_BASE --chown="root:root" --chmod="0755" /usr/local/bin /usr/local/bin

# Copy the load-certificates script, give permissions
COPY --chown="root:root" --chmod="0755" ./scripts/load-certificates.sh /usr/local/bin/load-certificates
RUN echo "${ENV_DEFAULT_USER} ALL=(ALL) NOPASSWD: /usr/local/bin/load-certificates" >> /etc/sudoers && \
    chmod 0755 -R /usr/local/share/ca-certificates/

#
# Actions as user
#

USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"

# Install Ansible, Molecule, comunity additions
COPY --chown="${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}" ./requirements.txt ./requirements.txt
RUN python3 -m pip install --no-cache-dir -r ./requirements.txt --break-system-packages && \
    export PATH="/$HOME/.local/bin:${PATH}" && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install community.docker

# Increase default docker timeout
ENV PATH="/$HOME/.local/bin:${PATH}"

# Checks & CMD
RUN ansible --version && \
    sonar-scanner -v && \
    node -v && \
    npm -v && \
    python3 -v && \
    load-certificates --help && \
    csplit --help
CMD ["sudo", "load-certificates", "--uri", "sonarqube.labo-cbz.net:443"]
