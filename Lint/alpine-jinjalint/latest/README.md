# alpine-jinjalint

## Summary

This Docker image, based on Alpine, is configured for Jinja2 template linting. It sets up a user and a default working directory, updates installed packages, and installs essential tools such as `make`, `bash`, and `python3`. It also installs `j2lint` for Jinja2 template linting. The version of `j2lint` is checked after installation. The default command (`CMD`) is set to display the `j2lint` version.
