pipeline {
    agent none

    environment { 
        DOCKER_HUB_REPOS_PASSWORD = credentials("DOCKER_HUB_REPOS_PASSWORD")
        DOCKER_HUB_REPOS_USERNAME = credentials("DOCKER_HUB_REPOS_USERNAME")
        NEXUS_JENKINS_LOGIN_PASSWORD = credentials("NEXUS_JENKINS_LOGIN_PASSWORD")
        NEXUS_REPOS_DOCKER_REGISTRY = credentials("NEXUS_REPOS_DOCKER_REGISTRY")
        NEXUS_REPOS_PASSWORD = credentials("NEXUS_REPOS_PASSWORD")
        NEXUS_REPOS_USERNAME = credentials("NEXUS_REPOS_USERNAME")
        SONAR_HOST_URL = credentials("SONAR_HOST_URL")
        SONAR_TOKEN = "${SONAR_TOKEN}"

        DOCKER_IMAGE_ALPINE_SONAR_SCANNER_CLI = "robincbz/alpine-sonarcli:latest"
        DOCKER_IMAGE_ALPINE_GIT = "robincbz/alpine-git:latest"
        DOCKER_IMAGE_ALPINE_RELEASE_CLI = "robincbz/alpine-releasecli:latest"
        DOCKER_IMAGE_ALPINE_DOCKERFILE_LINT = "robincbz/alpine-dockerfilelint:latest"
        DOCKER_IMAGE_DOCKER_DOCKERFILE_BUILD = "robincbz/docker-dockerfilebuild:latest"
        DOCKER_IMAGE_DOCKER_SECRET_LINT = "robincbz/alpine-secretlint:latest"
        DOCKER_IMAGE_DOCKER_SCOUT = "robincbz/docker-scout:latest"
    }        

    stages {
        stage("lint") {
            agent { 
                docker {
                    image "${DOCKER_IMAGE_ALPINE_DOCKERFILE_LINT}"
                    registryUrl "https://${NEXUS_REPOS_DOCKER_REGISTRY}"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                }
            }

            steps {
                sh "ls -all"
                sh "hadolint --help"
            }
        }
    }
}