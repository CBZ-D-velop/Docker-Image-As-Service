pipeline {
    agent any

    environment { 
        DOCKER_HUB_REPOS_PASSWORD = credentials('DOCKER_HUB_REPOS_PASSWORD')
        DOCKER_HUB_REPOS_USERNAME = credentials('DOCKER_HUB_REPOS_USERNAME')
        NEXUS_JENKINS_LOGIN_PASSWORD = credentials('NEXUS_JENKINS_LOGIN_PASSWORD')
        NEXUS_REPOS_DOCKER_REGISTRY = credentials('NEXUS_REPOS_DOCKER_REGISTRY')
        NEXUS_REPOS_PASSWORD = credentials('NEXUS_REPOS_PASSWORD')
        NEXUS_REPOS_USERNAME = credentials('NEXUS_REPOS_USERNAME')
        SONAR_HOST_URL = credentials('SONAR_HOST_URL')
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
                artifactDaysToKeepStr: "",
                artifactNumToKeepStr: "",
                daysToKeepStr: "",
                numToKeepStr: "10"
            )
        )
    }

    stages {
        stage("dockerfile-lint") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_ALPINE_DOCKERFILE_LINT"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh('hadolint --ignore DL3018 --ignore DL3013 --ignore DL3008 --ignore DL3009 --ignore DL3015 Dockerfile > ./hadolint.md')
                }
            }
        }

        stage("secret-lint") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_DOCKER_SECRET_LINT"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                sh('detect-secrets scan > ./detect-secrets-scan.md')
                sh('detect-secrets audit .secrets.baseline > ./detect-secrets-audit.md')
            }
        }

        stage("sonarqube-check") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_ALPINE_SONAR_SCANNER_CLI"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
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
                    alwaysPull true
                    reuseNode true
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh('docker login -u \"$DOCKER_HUB_REPOS_USERNAME\" -p \"$DOCKER_HUB_REPOS_PASSWORD\"')
                    sh('bash build --test-build')
                }
            }
        }

        stage("scout-build") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_DOCKER_SCOUT"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh('bash build --docker-scout')
                    sh('docker scout cves --exit-code --only-severity critical,high --format markdown --output ./cves-report.md local://local/${NAME}:docker-scout || true')
                    sh('$(docker scout recommendations local://local/${NAME}:docker-scout > ./cves-recommendations.md) || true')
                }
            }
        }

        stage("publish-build") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE_DOCKER_DOCKERFILE_BUILD"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
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
                    alwaysPull true
                    reuseNode true
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
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
        success {
            archiveArtifacts "$TYPE/$NAME/latest/*.md"
            cleanWs(
                    cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true
            )
        }

        failure {
            cleanWs(
                    cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true
            )
        }
        }

}