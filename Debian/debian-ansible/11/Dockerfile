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

LABEL VERSION="${ENV_VERSION}"
MAINTAINER ${ENV_MAINTAINER} <${ENV_MAINTAINER_ADDRESS}>

# Check if the user exists, and create it if not
RUN if ! id -u ${ENV_DEFAULT_USER} > /dev/null 2>&1; then \
        useradd -m ${ENV_DEFAULT_USER}; \
    fi

# Check if the work directory exists, and create it if not
RUN mkdir -p ${ENV_DEFAULT_WORKDIR}

# Set the working directory
WORKDIR ${ENV_DEFAULT_WORKDIR}

# Update the host, fix upgrade
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-mark hold debian-archive-keyring && apt update

# Install basics requirements
RUN apt install -y rsync curl python3 python3-jmespath python3-pip \
    python3-lxml libssl-dev libffi-dev git wget \
    lsb-release gnupg2 software-properties-common \
    apt-transport-https ca-certificates sudo nano \
    net-tools procps openssl lsof initscripts zip \
    tree python3-apt python3-pip python3-setuptools \
    iftop htop cron virtualenv nethogs iproute2 \
    git
