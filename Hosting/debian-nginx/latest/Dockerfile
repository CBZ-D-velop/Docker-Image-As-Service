# FROM stable-alpine3.17-slim
FROM nginx@sha256:0d441445722d39ce56b093a0067a745164973598af33e0aefc0127b85220d795

EXPOSE 80
EXPOSE 443

ARG MAINTAINER=""
ARG MAINTAINER_ADDRESS=""
ARG DEFAULT_USER=""
ARG DEFAULT_GROUP=""
ARG DEFAULT_WORKDIR=""

ARG PROJECT_WEB_ADDRESS
ARG PROJECT_WEB_CERTIFICATE_C
ARG PROJECT_WEB_CERTIFICATE_ST
ARG PROJECT_WEB_CERTIFICATE_L
ARG PROJECT_WEB_CERTIFICATE_O
ARG PROJECT_WEB_CERTIFICATE_OU
ARG PROJECT_WEB_CERTIFICATE_EMAIL_ADDRESS

ENV ENV_IMAGE_MAINTAINER="${IMAGE_MAINTAINER}" \
    ENV_IMAGE_MAINTAINER_ADDRESS="${IMAGE_MAINTAINER_ADDRESS}"

ENV ENV_DEFAULT_USER="${DEFAULT_USER}" \
    ENV_DEFAULT_GROUP="${DEFAULT_GROUP}" \
    ENV_DEFAULT_WORKDIR="${DEFAULT_WORKDIR}"

ENV ENV_PROJECT_WEB_ADDRESS="${PROJECT_WEB_ADDRESS}" \
    ENV_PROJECT_WEB_CERTIFICATE_C="${PROJECT_WEB_CERTIFICATE_C}" \
    ENV_PROJECT_WEB_CERTIFICATE_ST="${PROJECT_WEB_CERTIFICATE_ST}" \
    ENV_PROJECT_WEB_CERTIFICATE_L="${PROJECT_WEB_CERTIFICATE_L}" \
    ENV_PROJECT_WEB_CERTIFICATE_O="${PROJECT_WEB_CERTIFICATE_O}" \
    ENV_PROJECT_WEB_CERTIFICATE_OU="${PROJECT_WEB_CERTIFICATE_OU}" \
    ENV_PROJECT_WEB_CERTIFICATE_EMAIL_ADDRESS="${PROJECT_WEB_CERTIFICATE_EMAIL_ADDRESS}" \
    ENV_PROJECT_WEB_CERTIFICATE_CN="${ENV_DEFAULT_WEB_ADDRESS}" \
    ENV_PROJECT_WEB_CERTIFICATE_DNS="${ENV_DEFAULT_WEB_ADDRESS}"

LABEL "IMAGE_MAINTAINER"="${IMAGE_MAINTAINER} <${IMAGE_MAINTAINER_ADDRESS}>" \
      "IMAGE_MAINTAINER_ADDRESS"="${IMAGE_MAINTAINER_ADDRESS}"


# Check if the user exists, and create it if not
RUN if ! id -u ${ENV_DEFAULT_USER} > /dev/null 2>&1; then \
        adduser -D ${ENV_DEFAULT_GROUP}; \
    fi

# Update installed packages and clean cache
RUN apk update && \
    apk add --no-cache make bash openssl && \
    rm -rf /var/cache/apk/* && \
    rm -rf ~/.cache/*

# Check if the work directory exists, and create it if not
RUN mkdir -p ${ENV_DEFAULT_WORKDIR}
# Set the working directory
WORKDIR ${ENV_DEFAULT_WORKDIR}

# Import NGINX confs files
COPY ./nginx/configure_nginx.sh /etc/nginx/configure_nginx.sh
COPY ./nginx/default_http.conf /etc/nginx/default_http.conf
COPY ./nginx/default_https.conf /etc/nginx/default_https.conf
RUN cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bk

# Import SSL/TLS material generator
COPY ./ssl/configure_certificates.sh /etc/nginx/configure_certificates.sh

# Set CMD
COPY ./entrypoint/entrypoint.sh /entrypoint.sh

# Fix all permissions
RUN mkdir -p /var/www/html/ /var/cache/nginx /etc/nginx/ssl && \
    touch /var/run/nginx.pid && \
    chown -R ${ENV_DEFAULT_USER}:${ENV_DEFAULT_GROUP} \
    /entrypoint.sh \
    ${ENV_DEFAULT_WORKDIR} \
    /var/www/html /var/cache/nginx /etc/nginx \
    /var/run/nginx.pid && \
    chmod 0700 -R /entrypoint.sh \
    /var/www/html /var/cache/nginx /etc/nginx \
    /var/run/nginx.pid

USER "${ENV_DEFAULT_USER}":"${ENV_DEFAULT_GROUP}"
ENTRYPOINT ["/entrypoint.sh"]
