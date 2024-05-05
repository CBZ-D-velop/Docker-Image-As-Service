# alpine-releasecli

## Summary

This Docker image, based on `registry.gitlab.com/gitlab-org/release-cli:v0.16.0`, sets up an environment for running Git operations. It installs essential packages like `make`, `bash`, `git`, `openssl`, `openssh`, and `curl`. Additionally, it creates a user if it doesn't exist and sets up the working directory. The container is configured to run `ssh -V` by default.
