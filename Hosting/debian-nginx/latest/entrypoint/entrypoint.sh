#!/bin/bash
bash /etc/nginx/configure_certificates.sh
bash /etc/nginx/configure_nginx.sh

/usr/sbin/nginx -g "daemon off;"
