# alpine-nginx

## Summary

This Docker image, based on the Alpine version of NGINX, is configured to serve web content securely over HTTPS. It exposes ports 80 and 443 for HTTP and HTTPS traffic, respectively. The image sets up a user and a default working directory, updates installed packages, and cleans the cache. NGINX configuration files for both HTTP and HTTPS are imported, and SSL/TLS certificates are generated using the provided script. An entrypoint script is included to handle the NGINX service startup. Permissions are properly set for various directories and files, ensuring security and correct operation.
