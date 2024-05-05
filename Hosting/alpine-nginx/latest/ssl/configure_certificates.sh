#!/bin/bash

echo "=== CONFIGURE SSL CERTIFICATE ==="

mkdir -p /etc/nginx/ssl
cat << EOF > /etc/nginx/ssl/${ENV_PROJECT_WEB_ADDRESS}.req
[ req ]
default_bits=4096
prompt=no
req_extensions=req_ext
distinguished_name=dn

[ dn ]
C=${ENV_PROJECT_WEB_CERTIFICATE_C}
ST=${ENV_PROJECT_WEB_CERTIFICATE_ST}
L=${ENV_PROJECT_WEB_CERTIFICATE_L}
O=${ENV_PROJECT_WEB_CERTIFICATE_O}
OU=${ENV_PROJECT_WEB_CERTIFICATE_OU}
emailAddress=${ENV_PROJECT_WEB_CERTIFICATE_EMAIL_ADDRESS}
CN=${ENV_PROJECT_WEB_ADDRESS}

[ req_ext ]
subjectAltName=@alt_names

[ alt_names ]
DNS.1=${ENV_PROJECT_WEB_ADDRESS}
EOF

openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/${ENV_PROJECT_WEB_ADDRESS}.pem.key \
-out /etc/nginx/ssl/${ENV_PROJECT_WEB_ADDRESS}.pem.crt \
-config /etc/nginx/ssl/${ENV_PROJECT_WEB_ADDRESS}.req \
-days 3650 -nodes

echo "=== CONFIGURE SSL CERTIFICATE DONE ==="
