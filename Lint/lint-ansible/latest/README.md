# alpine-ansiblelint

## Summary

This Docker image, based on Alpine, is crafted for Ansible development tasks. It sets up a user and a default working directory, updates installed packages, and installs essential tools such as `make`, `bash`, and `gnupg`. Python and pip are installed and upgraded, and ansible-lint is installed and verified. Additionally, it installs basics requirements for Ansible such as `rsync`, `curl`, `python3`, `git`, `wget`, `nano`, `htop`, `iftop`, and others. Community collections for Ansible are also installed. The default command (`CMD`) is set to display the version of `ansible-lint`.
