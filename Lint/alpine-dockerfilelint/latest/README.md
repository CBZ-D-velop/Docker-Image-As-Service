# alpine-dockerfilelint

## Summary

This Docker image, based on Alpine, is tailored for Dockerfile linting and development tasks. It sets up a user and a default working directory, updates installed packages, and installs essential tools such as `make`, `bash`, `git`, and `shellcheck`. Additionally, it installs `hadolint` for Dockerfile linting. The version of `hadolint` is specified during the build process and verified after installation. The default command (`CMD`) is set to display `hadolint` help information.
