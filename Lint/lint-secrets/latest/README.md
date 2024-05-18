# alpine-secretlint

## Summary

The Docker image is built on Alpine Linux 3.18, tailored for development tasks. It includes essential tools like `make`, `bash`, `git`, `python3`, `curl`, etc., installed via `apk`. Python and pip are set up, and additional tools such as `j2lint` for Jinja2 template syntax validation are installed via pip from `requirements.txt`. After cleaning up temporary files and caches, the image runs the `detect-secrets` tool to display its version upon startup.
