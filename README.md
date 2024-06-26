# Docker-Image-As-Service

![Licence Status](https://img.shields.io/badge/licence-MIT-brightgreen)
![CI Status](https://img.shields.io/badge/CI-success-brightgreen)
![Language Status](https://img.shields.io/badge/language-Dockerfile-red)
![Compagny](https://img.shields.io/badge/Compagny-Labo--CBZ-blue)
![Author](https://img.shields.io/badge/Author-Lord%20Robin%20Cbz-blue)

## Description

![Tag: Docker](https://img.shields.io/badge/Tech-Docker-orange)

This Git repository serves as a valuable resource for managing Dockerfiles and associated scripts. Docker containers have become a cornerstone of modern software deployment, and this repository is designed to simplify the organization and maintenance of Docker images.

In addition to Dockerfiles, this repository also contains scripts that facilitate various tasks, such as managing image tags and versions, loading variables, and importing files into Docker images. These scripts streamline the Docker image creation and management process, making it easier to maintain a consistent and efficient containerized application stack.

Whether you're developing microservices, maintaining containerized applications, or building custom Docker images, this repository simplifies the process of Docker image management. It provides a structured and organized approach to Dockerfile storage and associated scripts, promoting efficiency and consistency in your containerization workflow.

By utilizing this Git repository, you can take full advantage of Docker's flexibility and portability while maintaining a well-structured and organized Docker image management strategy.

## Build a new image

You can build an image from a Dockerfile using the `./$TYPE/$NAME/latest/build` script. This script allows you to build your image while loading variables from the .env file (don't forget to edit the script if you add any variables).

This bash script automates the building and tagging of Docker images based on specified criteria and arguments. It also handles versioning and tagging of the images. To use this script, follow these steps:

1. Create a `.env` file with environment variables such as `MAINTAINER`, `MAINTAINER_ADDRESS`, `DEFAULT_USER`, `DEFAULT_GROUP`, and `DEFAULT_WORKDIR`.
2. Optionally, create a `.tag` file to maintain versioning information.
3. Execute the script with appropriate arguments.

The script supports the following arguments:

- `--major`: Increment the major version number by 1 and reset the minor version to 0, publish the builded image with `tag` and `latest`.
- `--dayli-build`: Generate a version with the current date and publish the builded image with `tag` and `latest`.
- `--test-build`: Generate a test build with the current version.
- `--docker-scout`: Build Docker image for scouting purposes, as `--test-build` but without any date informations.
- `--gitlab-ci`: Build Docker image for GitLab CI pipeline.
- `--jenkins-ci`: Build Docker image for Jenkins CI pipeline.

## Architectural Decisions Records

Here you can put your change to keep a trace of your work and decisions.

### 2023-10-03: First Init

- First init of this project by Lord Robin Crombez

### 2023-10-05: Added script for build

- Build script available to load vars, build, push, tag
- Argument --major available for Major versionning
- Added some Dockerfile

### 2023-10-06: Test / Lint pipeline

- This repository have a CI/CD to lint Dockerfiles (setted to lates)
- This repository have a CI/CD to build Dockerfiles in --test-build mode (setted to lates)
- This repository can be forked and modified to lint, build, analyse and push image from Dockerfile

### 2023-11-02: Docker Image As Service

- All images are now builded and updated by the CICD pipeline
- New tag for the build with the current version / latest

### 2024-02-19: Updates majors

- New CICD for image building
- Added Docker Dind for Ansible dev
- Added Debian 12 for Ansible dev
- Added Ubuntu 22 for Ansible dev
- Fix all images build
- Added for major versions
- Added passlib python lib for password hash
- Added Alpine Git, to publish

### 2024-03-26/25: New CICD

- Images follow a new CICD besed on DevSecOps and AS SERVICE
- Each image / Dockerfile is analysed separatly
- Added Sonarqube, for global quality
- Added Hadolint, specialized support
- Added detect-secrets for secret detection in images
- Added Docker Scout as layer analysis

### 2024-03-29: Jenkins CI

- Added a Jenkins CI to dayli build images based on cron
- Reworks on build script, added/updated options

### 2024-05-19: GitLab / Jenkins CI

- Rework on CI names
- Will not edit containers because not mandatory
- Added artefact analysis upload

## Authors

- Lord Robin Crombez

## Sources

- [husiang/yamllint](https://hub.docker.com/r/chusiang/yamllint/dockerfile)
- [Installing Python in Alpine Linux](https://www.askpython.com/python/examples/python-alpine-linux)
- [Install Python on Alpine Linux](https://devcoops.com/install-python-on-alpine-linux/)
- [alpine:3.18](https://hub.docker.com/layers/library/alpine/3.18/images/sha256-48d9183eb12a05c99bcc0bf44a003607b8e941e1d4f41f9ad12bdcc4b5672f86?context=explore)
- [j2lint](https://github.com/aristanetworks/j2lint)
