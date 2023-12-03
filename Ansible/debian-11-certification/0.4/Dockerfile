# FROM 11
FROM debian@sha256:4effa16ae79ab36347d55ebb6bb4aad411077b72ad735054e684b3eeba373a35

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
        useradd -m ${ENV_DEFAULT_USER}; \
    fi

# Check if the work directory exists, and create it if not
RUN mkdir -p ${ENV_DEFAULT_WORKDIR}

# Set the working directory
WORKDIR ${ENV_DEFAULT_WORKDIR}

# Update the host, fix upgrade
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-mark hold debian-archive-keyring && apt-get update && apt-get upgrade -y && \
    apt-get upgrade debian-archive-keyring -y --allow-change-held-packages

# Install basics requirements
RUN apt-get install --no-install-recommends -y \
    rsync curl python3 python3-jmespath python3-pip \
    python3-lxml gnupg2 software-properties-common \
    apt-transport-https ca-certificates sudo \
    openssl zip python3-apt python3-pip python3-setuptools \
    init bzip2 tar unzip gpg && \
    gpg --version && openssl version

# CLear all apt files
RUN apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y && \
    apt-get autoremove --purge -y && rm -rf /var/lib/apt/lists/*

# Install python and pip
RUN python3 -m pip install --no-cache-dir requests && \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools && \
    python3 -m ensurepip && \
    python3 --version

# Install comunity additions
COPY --chown="${DEFAULT_USER}:${DEFAULT_GROUP}" ./requirements.txt ./requirements.txt
RUN python3 -m pip install --no-cache-dir -r ./requirements.txt && \
    python3 -m pip install --no-cache-dir requests && \
    ansible --version

# Set CMD
USER "${DEFAULT_USER}":"${DEFAULT_GROUP}"
CMD ["/sbin/init"]
