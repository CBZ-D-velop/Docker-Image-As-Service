pipeline {
    agent any

    environment { 
        string(variable: 'DOCKER_HUB_REPOS_PASSWORD', credentialsId: 'DOCKER_HUB_REPOS_PASSWORD')
        string(variable: 'DOCKER_HUB_REPOS_USERNAME', credentialsId: 'DOCKER_HUB_REPOS_USERNAME')
        string(variable: 'NEXUS_JENKINS_LOGIN_PASSWORD', credentialsId: 'NEXUS_JENKINS_LOGIN_PASSWORD')
        string(variable: 'NEXUS_REPOS_DOCKER_REGISTRY', credentialsId: 'NEXUS_REPOS_DOCKER_REGISTRY')
        string(variable: 'NEXUS_REPOS_PASSWORD', credentialsId: 'NEXUS_REPOS_PASSWORD')
        string(variable: 'NEXUS_REPOS_USERNAME', credentialsId: 'NEXUS_REPOS_USERNAME')
        string(variable: 'SONAR_HOST_URL', credentialsId: 'SONAR_HOST_URL')
        SONAR_TOKEN = "$SONAR_TOKEN"

        DOCKER_IMAGE_ALPINE_SONAR_SCANNER_CLI = 'robincbz/alpine-sonarcli:latest'
        DOCKER_IMAGE_ALPINE_GIT = 'robincbz/alpine-git:latest'
        DOCKER_IMAGE_ALPINE_RELEASE_CLI = 'robincbz/alpine-releasecli:latest'
        DOCKER_IMAGE_ALPINE_DOCKERFILE_LINT = 'robincbz/alpine-dockerfilelint:latest'
        DOCKER_IMAGE_DOCKER_DOCKERFILE_BUILD = 'robincbz/docker-dockerfilebuild:latest'
        DOCKER_IMAGE_DOCKER_SECRET_LINT = 'robincbz/alpine-secretlint:latest'
        DOCKER_IMAGE_DOCKER_SCOUT = 'robincbz/docker-scout:latest'
    }        

    options {
        buildDiscarder(
            logRotator(      
                artifactDaysToKeepStr: "30",
                artifactNumToKeepStr: "",
                daysToKeepStr: "",
                numToKeepStr: ""
            )
        )
    }

    stages {
        stage("lint") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_ALPINE_DOCKERFILE_LINT"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh('hadolint --ignore DL3018 --ignore DL3013 --ignore DL3008 --ignore DL3009 --ignore DL3015 Dockerfile')
                }
            }
        }

        stage("secret") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_DOCKER_SECRET_LINT"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                }
            }

            steps {
                sh('detect-secrets scan')
                sh('detect-secrets audit .secrets.baseline')
            }
        }

        stage("sonarqube") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_ALPINE_SONAR_SCANNER_CLI"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                }
            }

            steps {
                sh('sonar-scanner')
            }
        }

        stage("test-build") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_DOCKER_DOCKERFILE_BUILD"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    args "-v /var/run/docker.sock:/var/run/docker.sock"
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh('bash build --test-build')
                }
            }
        }

        stage("publish") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_DOCKER_DOCKERFILE_BUILD"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    args "-v /var/run/docker.sock:/var/run/docker.sock"
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh('docker login -u \"$DOCKER_HUB_REPOS_USERNAME\" -p \"$DOCKER_HUB_REPOS_PASSWORD\"')
                    sh('bash build --jenkins-ci')
                }
            }
        }

        stage("dayli-build") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_DOCKER_DOCKERFILE_BUILD"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    args "-v /var/run/docker.sock:/var/run/docker.sock"
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh('docker login -u \"$DOCKER_HUB_REPOS_USERNAME\" -p \"$DOCKER_HUB_REPOS_PASSWORD\"')
                    sh('bash build --dayli-build')
                }
            }
        }
    }

    post {
        always {
            deleteDir()
        }
    }
}