# FROM 11
FROM debian@sha256:4effa16ae79ab36347d55ebb6bb4aad411077b72ad735054e684b3eeba373a35

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

# Install basics requirements
RUN apt-get install --no-install-recommends -y \
    rsync curl git python3 python3-jmespath python3-pip \
    python3-lxml gnupg2 software-properties-common \
    apt-transport-https ca-certificates sudo \
    openssl zip python3-apt python3-pip python3-setuptools \
    init bzip2 tar unzip gpg && \
    gpg --version && openssl version && git --version

# CLear all apt files
RUN apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y && \
    apt-get autoremove --purge -y && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install python and pip
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 --version

# Install comunity additions
WORKDIR "${ENV_DEFAULT_WORKDIR}"
COPY --chown="${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP}" ./requirements.txt ./requirements.txt
RUN python3 -m pip install --no-cache-dir -r ./requirements.txt --break-system-packages && \
    ansible --version

# Set CMD
USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"
CMD ["/sbin/init"]
