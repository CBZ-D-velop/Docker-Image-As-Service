#!/bin/bash

# Import default conf template
# Configure NGINX
cp ${ENV_DEFAULT_USER_HOME}/templates/nginx.conf.template /etc/nginx/nginx.conf && \
sed -i "s#{{user}}#${ENV_NGINX_USER}#g" /etc/nginx/nginx.conf && \
sed -i "s#{{worker_processes}}#${ENV_NGINX_WORKER_PROCESSES}#g" /etc/nginx/nginx.conf && \
sed -i "s#{{worker_connections}}#${ENV_NGINX_WORKER_CONNECTIONS}#g" /etc/nginx/nginx.conf && \
sed -i "s#{{server_name}}#${ENV_NGINX_SERVER_NAME}#g" /etc/nginx/nginx.conf && \
sed -i "s#{{root}}#${ENV_NGINX_ROOT}#g" /etc/nginx/nginx.conf && \
sed -i "s#{{index}}#${ENV_NGINX_INDEX}#g" /etc/nginx/nginx.conf

# Generate private key
openssl genrsa -out /etc/nginx/ssl/${ENV_NGINX_SERVER_NAME}.pem.key 4096 && \
openssl req -new -key /etc/nginx/ssl/${ENV_NGINX_SERVER_NAME}.pem.key -out /etc/nginx/ssl/${ENV_NGINX_SERVER_NAME}.csr -subj "/C=${NGINX_SERVER_COUNTRY}/CN=${ENV_NGINX_SERVER_NAME}" && \
openssl x509 -req -days 365 -in /etc/nginx/ssl/${ENV_NGINX_SERVER_NAME}.csr -signkey /etc/nginx/ssl/${ENV_NGINX_SERVER_NAME}.pem.key -out /etc/nginx/ssl/${ENV_NGINX_SERVER_NAME}.pem.crt && \

# Start NGINX
/usr/sbin/nginx -g  "daemon off;"
