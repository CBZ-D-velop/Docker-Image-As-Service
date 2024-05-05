# FROM 5.0
FROM sonarsource/sonar-scanner-cli@sha256:494ecc3b5b1ee1625bd377b3905c4284e4f0cc155cff397805a244dee1c7d575

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_WORKDIR=""

ARG DEFAULT_NPM_VERSION=""
ARG DEFAULT_NODEJS_VERSION=""

ENV ENV_MAINTAINER="${MAINTAINER}"
ENV ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}"

ENV ENV_DEFAULT_USER="${DEFAULT_USER}"
ENV ENV_DEFAULT_GROUP="${DEFAULT_GROUP}"
ENV ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}"
ENV ENV_VERSION="${VERSION}"

ENV ENV_DEFAULT_NPM_VERSION="${DEFAULT_NPM_VERSION}"
ENV ENV_DEFAULT_NODEJS_VERSION="${DEFAULT_NODEJS_VERSION}"

LABEL "version"="${ENV_VERSION}"
LABEL "maintainer"="${ENV_MAINTAINER} <${ENV_MAINTAINER_ADDRESS}>"
LABEL "maintainer-address"="${ENV_MAINTAINER_ADDRESS}"

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
    apk add --no-cache curl openssl wget gnupg

COPY certs/* /usr/local/share/ca-certificates/
RUN update-ca-certificates && \
    openssl verify /usr/local/share/ca-certificates/sonarqube.labo-cbz.net.pem.crt

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
WORKDIR "${ENV_DEFAULT_WORKDIR}"
COPY --chown="${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP}" ./requirements.txt ./requirements.txt
RUN python3 -m pip install --no-cache-dir -r ./requirements.txt --break-system-packages && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install community.docker && \
    ansible --version

# Install npm / nodejs
RUN apk add --no-cache --update npm nodejs &&\
    node -v && \
    npm -v

# Remove packages cache
RUN apk del build-dependencies; \
    rm -rf /var/cache/apk/* && \
    rm -rf ~/.cache/*

# Set CMD
USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"
CMD ["sonar-scanner"]
