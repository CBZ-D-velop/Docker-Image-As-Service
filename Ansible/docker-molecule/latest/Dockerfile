# FROM dind
FROM docker:dind

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
    python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools --break-system-packages && \
    python3 --version

# Isntall molecule
# Install comunity additions
COPY --chown="${DEFAULT_USER}:${DEFAULT_GROUP}" ./requirements.txt ./requirements.txt
RUN python3 -m pip install --break-system-packages --no-cache-dir -r ./requirements.txt && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install community.docker && \
    ansible --version && \
    molecule --version

# Remove packages cache
RUN apk del build-dependencies; \
    rm -rf /var/cache/apk/* && \
    rm -rf ~/.cache/*

# Set CMD
USER "${DEFAULT_USER}":"${DEFAULT_GROUP}"
CMD ["molecule", "--version"]
