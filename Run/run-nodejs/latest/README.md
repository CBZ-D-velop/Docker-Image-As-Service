# debian-npmbuild

## Summary

This Docker image, based on the Node.js image, is designed to facilitate Node.js development tasks. It creates a user and a default working directory if they do not already exist. The image ensures a non-interactive system upgrade and installs essential tools such as `git`, `curl`, `wget`, `openssl`, `ssh`, `zip`, `unzip`, `tar`, and `gzip`. After installation, package cache is cleared to save space. The versions of `zip`, `npm`, `node`, `tar`, and `gzip` are verified. The default command (`CMD`) is set to display the version of `npm`.
