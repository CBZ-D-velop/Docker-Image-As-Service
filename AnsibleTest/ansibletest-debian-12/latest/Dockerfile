# FROM 12.5
FROM debian@sha256:fc27237003ad8ffa4608590057eed4e1db8ce6098434b5ecda23f533a5b12e56

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
        addgroup --group "${ENV_DEFAULT_GROUP}" --gid "${ENV_DEFAULT_GROUP_GID}"; \
    fi && \
    if ! id -u "${ENV_DEFAULT_USER}" > /dev/null 2>&1; then \
        useradd -l -u "${ENV_DEFAULT_USER_ID}" -g "${ENV_DEFAULT_GROUP}" \
        --home "${ENV_DEFAULT_USER_HOME}" --shell "/bin/bash" "${ENV_DEFAULT_USER}"; \
    fi && \
    mkdir -p ${ENV_DEFAULT_WORKDIR} && chmod 0700 -R ${ENV_DEFAULT_WORKDIR} && chown -R ${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP} ${ENV_DEFAULT_WORKDIR}

# Update the host, fix upgrade
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-mark hold debian-archive-keyring && apt-get update && apt-get upgrade -y && \
    apt-get upgrade debian-archive-keyring -y --allow-change-held-packages && \
    apt-get clean

# Install basics requirements, and others packages
RUN apt-get install --no-install-recommends -y \
    rsync curl git gnupg2 software-properties-common \
    apt-transport-https ca-certificates sudo \
    openssl zip init bzip2 tar unzip gpg apt-utils usrmerge && \
    apt-get clean

#
# Actions as root

# Install basics requirements for Ansible run / tests
RUN apt-get install --no-install-recommends -y \
    python3 python3-jmespath python3-pip \
    python3-lxml libssl-dev libffi-dev wget \
    lsb-release gnupg2 software-properties-common \
    apt-transport-https ca-certificates sudo nano \
    net-tools procps lsof \
    tree python3-apt python3-pip python3-setuptools \
    iftop htop cron virtualenv nethogs iproute2 \
    locales iptables-persistent && \
    apt-get autoclean -y && apt-get clean -y && apt-get autoremove -y && \
    apt-get autoremove --purge -y && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    python3 -m pip install --break-system-packages --no-cache-dir --upgrade pip

# Install Python requirements
WORKDIR "${HOME}"
COPY --chown="root:root" ./requirements.txt ./requirements.txt
RUN rm /usr/lib/python3.*/EXTERNALLY-MANAGED && \
    python3 -m pip install --break-system-packages --no-cache-dir -r ./requirements.txt
ENV PATH="/$HOME/.local/bin:${PATH}"

# Checks & CMD
USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"
CMD ["/sbin/init"]
