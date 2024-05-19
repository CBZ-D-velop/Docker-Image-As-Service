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
        DOCKER_IMAGE__ANALYSE_SONAR_SCANNER = "labocbz/analyse-sonar-scanner:latest"
        DOCKER_IMAGE__ANALYSE_DOCKER_IMAGE = "labocbz/analyse-docker-image:latest"
        DOCKER_IMAGE__BUILD_DOCKERFILE = "labocbz/build-dockerfile:latest"
        DOCKER_IMAGE__LINT_DOCKERFILE = "labocbz/lint-dockerfile:0.4"
        DOCKER_IMAGE__LINT_SECRETS = "labocbz/lint-secrets:0.4"
        DOCKER_IMAGE__LINT_MARKDOWN = "labocbz/lint-markdown:0.4"
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
                    image "$DOCKER_IMAGE__LINT_DOCKERFILE"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh("#!/bin/bash\n hadolint --ignore DL3018 --ignore DL3013 --ignore DL3008 --ignore DL3009 --ignore DL3015 Dockerfile > ./hadolint.md")
                }
            }
        }

        stage("secret-lint") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE__LINT_SECRETS"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                sh("#!/bin/bash\n detect-secrets scan > ./$TYPE/$NAME/latest/detect-secrets-scan.md")
                sh("#!/bin/bash\n detect-secrets audit .secrets.baseline > ./$TYPE/$NAME/latest/detect-secrets-audit.md")
            }
        }

        stage("markdown-lint") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE__LINT_MARKDOWN"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                dir("$TYPE/$NAME/latest") {
                    sh("#!/bin/bash\n markdownlint './README.md' --disable MD013 > ./hadolint.md")
                }
            }
        }

        stage("sonarqube-check") {
            agent { 
                docker {
                    image "$DOCKER_IMAGE__ANALYSE_SONAR_SCANNER"
                    registryUrl "https://$NEXUS_REPOS_DOCKER_REGISTRY"
                    registryCredentialsId "NEXUS_JENKINS_LOGIN_PASSWORD"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                sh("#!/bin/bash\n sonar-scanner")
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
                    sh("#!/bin/bash\n docker login -u \"$DOCKER_HUB_REPOS_USERNAME\" -p \"$DOCKER_HUB_REPOS_PASSWORD\"")
                    sh("#!/bin/bash\n bash build --test-build")
                }
            }
        }

        stage("scout-cve") {
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
                    sh("#!/bin/bash\n bash build --docker-scout")
                    sh("#!/bin/bash\n docker login -u \"$DOCKER_HUB_REPOS_USERNAME\" -p \"$DOCKER_HUB_REPOS_PASSWORD\"")
                    sh("#!/bin/bash\n ~/.docker/cli-plugins/docker-scout cves --exit-code --only-severity critical,high --format markdown local://local/${NAME}:docker-scout > ./cves-report.md || true")
                    sh("#!/bin/bash\n ~/.docker/cli-plugins/docker-scout recommendations local://local/${NAME}:docker-scout > ./cves-recommendations.md || true")
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
                    sh("#!/bin/bash\n docker login -u \"$DOCKER_HUB_REPOS_USERNAME\" -p \"$DOCKER_HUB_REPOS_PASSWORD\"")
                    sh("#!/bin/bash\n bash build --jenkins-ci")
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
                    sh("#!/bin/bash\n docker login -u \"$DOCKER_HUB_REPOS_USERNAME\" -p \"$DOCKER_HUB_REPOS_PASSWORD\"")
                    sh("#!/bin/bash\n bash build --dayli-build")
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
