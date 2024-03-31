
#!/bin/bash

echo "=== CONFIGURE NGINX ==="

cp /etc/nginx/default_http.conf /etc/nginx/conf.d/default_http.conf
cp /etc/nginx/default_https.conf /etc/nginx/conf.d/default_https.conf
cp /etc/nginx/nginx.conf.bk /etc/nginx/nginx.conf

sed -i "s/nginx;/${ENV_IMAGE_DEFAULT_USER};/g" /etc/nginx/nginx.conf
sed -i "s/localhost/${ENV_PROJECT_WEB_ADDRESS}/g" /etc/nginx/conf.d/default_http.conf
sed -i "s/localhost/${ENV_PROJECT_WEB_ADDRESS}/g" /etc/nginx/conf.d/default_https.conf

echo "=== CONFIGURE NGINX DONE ==="
