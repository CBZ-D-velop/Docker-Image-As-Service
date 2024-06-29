# FROM stable-alpine3.17-slim
FROM nginx@sha256:0d441445722d39ce56b093a0067a745164973598af33e0aefc0127b85220d795

EXPOSE 80
EXPOSE 443

ARG VERSION=""
ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_USER_ID=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_GROUP_GID=""
ARG DEFAULT_USER_HOME=""
ARG DEFAULT_WORKDIR=""
ARG NGINX_USER=""
ARG NGINX_WORKER_PROCESSES=""
ARG NGINX_WORKER_CONNECTIONS=""
ARG NGINX_SERVER_NAME=""
ARG NGINX_ROOT=""
ARG NGINX_INDEX=""
ARG NGINX_HOST_TYPE=""
ARG NGINX_SERVER_COUNTRY=""

ENV VERSION="${VERSION}" \
    ENV_MAINTAINER="${MAINTAINER}" \
    ENV_MAINTAINER_ADDRESS="${MAINTAINER_ADDRESS}" \
    ENV_DEFAULT_USER="${DEFAULT_USER}" \
    ENV_DEFAULT_USER_ID="${DEFAULT_USER_ID}" \
    ENV_DEFAULT_GROUP="${DEFAULT_GROUP}" \
    ENV_DEFAULT_GROUP_GID="${DEFAULT_GROUP_GID}" \
    ENV_DEFAULT_USER_HOME="${DEFAULT_USER_HOME}" \
    ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}" \
    ENV_NGINX_USER="${NGINX_USER}" \
    ENV_NGINX_WORKER_PROCESSES="${NGINX_WORKER_PROCESSES}" \
    ENV_NGINX_WORKER_CONNECTIONS="${NGINX_WORKER_CONNECTIONS}" \
    ENV_NGINX_SERVER_NAME="${NGINX_SERVER_NAME}" \
    ENV_NGINX_ROOT="${NGINX_ROOT}" \
    ENV_NGINX_INDEX="${NGINX_INDEX}" \
    ENV_NGINX_HOST_TYPE="${NGINX_HOST_TYPE}" \
    ENV_NGINX_SERVER_COUNTRY="${NGINX_SERVER_COUNTRY}"

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
    rsync curl git gnupg wget \
    sudo openssl zip bzip2 tar unzip gpg  bash&& \
    rm -rf /var/cache/apk/*

#
# Actions as root
#

# Import the template NGINX file, prepare directories
RUN mkdir -p "${ENV_DEFAULT_USER_HOME}/templates" "${ENV_DEFAULT_USER_HOME}/entrypoint" "${ENV_NGINX_ROOT}" "/var/log/nginx" "/var/cache/nginx" "/etc/nginx/ssl" && \
    chown -R ${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP} "${ENV_DEFAULT_USER_HOME}/templates" "/var/log/nginx" "${ENV_DEFAULT_USER_HOME}/entrypoint" "${ENV_NGINX_ROOT}" "/var/cache/nginx" "/etc/nginx" && \
    chmod 0700 -R "${ENV_DEFAULT_USER_HOME}/templates" "${ENV_DEFAULT_USER_HOME}/entrypoint" "/var/log/nginx" "${ENV_NGINX_ROOT}" "/var/cache/nginx" "/etc/nginx" && \
    touch /var/run/nginx.pid && chmod 0700 /var/run/nginx.pid && chown -R ${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP} /var/run/nginx.pid
COPY --chown="${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP}" --chmod=0700 ./scripts/entrypoint.sh "${ENV_DEFAULT_USER_HOME}/entrypoint/entrypoint.sh"
COPY --chown="${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP}" --chmod=0700 ./nginx/${ENV_NGINX_HOST_TYPE}_nginx.conf "${ENV_DEFAULT_USER_HOME}/templates/nginx.conf.template"

#
# Actions as user
#
USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
WORKDIR "${ENV_DEFAULT_WORKDIR}"

# Import the default index file
RUN mkdir -p "${ENV_NGINX_ROOT}"
COPY --chown="${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP}" --chmod=0700 ./nginx/index.html "${ENV_NGINX_ROOT}/${ENV_NGINX_INDEX}"

# Checks & ENTRYPOINT
ENTRYPOINT ["/bin/bash", "-c", "${ENV_DEFAULT_USER_HOME}/entrypoint/entrypoint.sh"]
