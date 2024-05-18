# alpine-git

## Summary

This Docker image, based on Alpine Linux, sets up a minimal environment for running SSH commands. It installs essential packages like `make`, `bash`, `git`, `openssl`, `openssh`, and `curl`. Additionally, it creates a user if it doesn't exist and sets up the working directory. The container is configured to run `ssh -V` by default.
