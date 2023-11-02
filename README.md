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

You can build an image from a Dockerfile using the ./build script. This script allows you to build your image while loading variables from the .env file (don't forget to edit the script if you add any variables).

After that, the script can take two arguments or none:

* ./build: This command simply builds the Dockerfile, loads variables, adds 0.1 to the current version or tag, and initializes the project if it hasn't been previously built. The resulting image will be pushed to the repository, a new folder will be created, and all the contents of the latest folder will be copied (excluding the build script or the .tag file).

* ./build --major: This command creates a new major version tag. If the current version is 0.12, the next major version will be 1.0. The resulting image will be pushed to the repository, a new folder will be created, and all the contents of the latest folder will be copied (excluding the build script or the .tag file).

* ./build --testbuild: This command will only build the Dockerfile without incrementing the current version or pushing it to the repository. The created image will be tagged as "testbuild-version". This command is intended for testing the Dockerfile. Layers are not deleted, image just builded to, so next build will be more fast.

* ./build --cicdbuild: This command is used inside the CI/CD pipeline. Any run will build the image as "cicd-current_latest_version" and push into the Docker repository. So 1 tag is created or updated and the latest tag is to. The goal of this option if to automated the process of image building, as service.

```SHELL
# Build the latest image, from Ansible/debian-11-ansible/latest
cd ./Ansible/debian-11-ansible
ls -all
drwxr-xr-x 5 xxxx xxxx 4096  5 oct.  15:12 .
drwxr-xr-x 4 xxxx xxxx 4096  5 oct.  15:04 ..
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:07 0.1
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:12 1.0
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  11:45 latest
cd latest
./build
ls ../ -all
drwxr-xr-x 5 xxxx xxxx 4096  5 oct.  15:12 .
drwxr-xr-x 4 xxxx xxxx 4096  5 oct.  15:04 ..
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:07 0.1
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:12 1.0
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:12 1.1 # NEW VERSION HERE
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  11:45 latest
```

```SHELL
# Build the latest image, from Ansible/debian-11-ansible/latest, but pass in another major version
cd ./Ansible/debian-11-ansible
ls -all
drwxr-xr-x 5 xxxx xxxx 4096  5 oct.  15:12 .
drwxr-xr-x 4 xxxx xxxx 4096  5 oct.  15:04 ..
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:07 0.1
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:12 1.0
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  11:45 latest
cd latest
./build --major
ls ../ -all
drwxr-xr-x 5 xxxx xxxx 4096  5 oct.  15:12 .
drwxr-xr-x 4 xxxx xxxx 4096  5 oct.  15:04 ..
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:07 0.1
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:12 1.0
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:12 2.0 # NEW MAJOR VERSION HERE
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  11:45 latest
```

```SHELL
# Build the latest image, from Ansible/debian-11-ansible/latest, but it just a build test
cd ./Ansible/debian-11-ansible
ls -all
drwxr-xr-x 5 xxxx xxxx 4096  5 oct.  15:12 .
drwxr-xr-x 4 xxxx xxxx 4096  5 oct.  15:04 ..
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:07 0.1
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:12 1.0
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  11:45 latest
cd latest
./build --testbuild
ls ../ -all
drwxr-xr-x 5 xxxx xxxx 4096  5 oct.  15:12 .
drwxr-xr-x 4 xxxx xxxx 4096  5 oct.  15:04 ..
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:07 0.1
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  15:12 1.0
drwxr-xr-x 2 xxxx xxxx 4096  5 oct.  11:45 latest # NOTHING NEW HERE
```

## Architectural Decisions Records

Here you can put your change to keep a trace of your work and decisions.

### 2023-10-03: First Init

* First init of this project by Lord Robin Crombez

### 2023-10-05: Added script for build

* Build script available to load vars, build, push, tag
* Argument --major available for Major versionning
* Added some Dockerfile

### 2023-10-06: Test / Lint pipeline

* This repository have a CI/CD to lint Dockerfiles (setted to lates)
* This repository have a CI/CD to build Dockerfiles in --testbuild mode (setted to lates)
* This repository can be forked and modified to lint, build, analyse and push image from Dockerfile

### 2023-11-02: Docker Image As Service

* All images are now builded and updated by the CICD pipeline
* New tag for the build with the current version / latest

## Authors

* Lord Robin Crombez

## Sources

* [husiang/yamllint](https://hub.docker.com/r/chusiang/yamllint/dockerfile)
* [Installing Python in Alpine Linux](https://www.askpython.com/python/examples/python-alpine-linux)
* [Install Python on Alpine Linux](https://devcoops.com/install-python-on-alpine-linux/)
* [alpine:3.18](https://hub.docker.com/layers/library/alpine/3.18/images/sha256-48d9183eb12a05c99bcc0bf44a003607b8e941e1d4f41f9ad12bdcc4b5672f86?context=explore)
* [j2lint](https://github.com/aristanetworks/j2lint)
