pipeline {
    agent any

    environment {
        DOCKER_IMAGE__ANALYSE_SONAR_SCANNER = "labocbz/analyse-sonar-scanner:latest"
        DOCKER_IMAGE__ANALYSE_DOCKER_IMAGE = "labocbz/analyse-docker-image:latest"
        DOCKER_IMAGE__BUILD_DOCKERFILE = "labocbz/build-dockerfile:latest"
        DOCKER_IMAGE__LINT_DOCKERFILE = "labocbz/lint-dockerfile:0.2"
        DOCKER_IMAGE__LINT_SECRETS = "labocbz/lint-secrets:0.2"
        DOCKER_IMAGE__LINT_MARKDOWN = "labocbz/lint-markdown:0.2"

        NEXUS_DOCKER_GROUP_REGISTRY = credentials('NEXUS_DOCKER_GROUP_REGISTRY')
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
        stage("lint:dockerfile") {
            agent {
                docker {
                    image "${DOCKER_IMAGE__LINT_DOCKERFILE}"
                    registryUrl "https://${NEXUS_DOCKER_GROUP_REGISTRY}"
                    registryCredentialsId "JENKINS_CI_NEXUS_CREDENTIALS"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                dir("${TYPE}/${NAME}/latest") {
                    sh("#!/bin/bash\n hadolint --ignore DL3001 --ignore DL3018 --ignore DL3013 --ignore DL3008 --ignore DL3009 --ignore DL3015 Dockerfile > ./hadolint.md")
                }
            }
        }

        stage("lint:secrets") {
            agent {
                docker {
                    image "${DOCKER_IMAGE__LINT_SECRETS}"
                    registryUrl "https://${NEXUS_DOCKER_GROUP_REGISTRY}"
                    registryCredentialsId "JENKINS_CI_NEXUS_CREDENTIALS"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                sh("#!/bin/bash\n detect-secrets scan > ./${TYPE}/${NAME}/latest/detect-secrets-scan.md")
                sh("#!/bin/bash\n detect-secrets audit .secrets.baseline > ./${TYPE}/${NAME}/latest/detect-secrets-audit.md")
            }
        }

        stage("lint:markdown") {
            agent {
                docker {
                    image "${DOCKER_IMAGE__LINT_MARKDOWN}"
                    registryUrl "https://${NEXUS_DOCKER_GROUP_REGISTRY}"
                    registryCredentialsId "JENKINS_CI_NEXUS_CREDENTIALS"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                dir("${TYPE}/${NAME}/latest") {
                    sh("#!/bin/bash\n markdownlint './README.md' --disable MD013 > ./hadolint.md")
                }
            }
        }

        stage("sonarqube-check") {
            agent {
                docker {
                    image "${DOCKER_IMAGE__ANALYSE_SONAR_SCANNER}"
                    registryUrl "https://${NEXUS_DOCKER_GROUP_REGISTRY}"
                    registryCredentialsId "JENKINS_CI_NEXUS_CREDENTIALS"
                    alwaysPull true
                    reuseNode true
                }
            }

            steps {
                withCredentials([
                    string(credentialsId: "SONARQUBE_ADDRESS", variable: "SONAR_HOST_URL"),
                    string(credentialsId: "JENKINS_CI_SONARQUBE_USER_TOKEN", variable: "SONAR_TOKEN")
                ]) {
                    sh("#!/bin/bash\n sonar-scanner")
                }
            }
        }

        stage("build") {
            agent {
                docker {
                    image "${DOCKER_IMAGE__BUILD_DOCKERFILE}"
                    registryUrl "https://${NEXUS_DOCKER_GROUP_REGISTRY}"
                    registryCredentialsId "JENKINS_CI_NEXUS_CREDENTIALS"
                    alwaysPull true
                    reuseNode true
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }

            steps {
                dir("${TYPE}/${NAME}/latest") {
                    sh("#!/bin/bash\n bash build --test")
                }
            }
        }

        stage("scout-analyse") {
            agent {
                docker {
                    image "${DOCKER_IMAGE__ANALYSE_DOCKER_IMAGE}"
                    registryUrl "https://${NEXUS_DOCKER_GROUP_REGISTRY}"
                    registryCredentialsId "JENKINS_CI_NEXUS_CREDENTIALS"
                    alwaysPull true
                    reuseNode true
                    args "-u root:root -v /var/run/docker.sock:/var/run/docker.sock"
                }
            }

            steps {
                withCredentials([string(credentialsId: "JENKINS_CI_DOCKER_HUB_CREDENTIALS", variable: "JENKINS_CI_DOCKER_HUB_CREDENTIALS")]) {
                    dir("${TYPE}/${NAME}/latest") {
                        sh("#!/bin/bash\n bash build --scout")
                        sh("#!/bin/bash\n docker login -u \"${JENKINS_CI_DOCKER_HUB_CREDENTIALS_USR}\" --password-stdin \"${JENKINS_CI_DOCKER_HUB_CREDENTIALS_PSW}\"")
                        sh("#!/bin/bash\n ~/.docker/cli-plugins/docker-scout cves --exit-code --only-severity critical,high --format markdown local://local/${NAME}:latest-scout > ./cves-report.md || true")
                        sh("#!/bin/bash\n ~/.docker/cli-plugins/docker-scout recommendations local://local/${NAME}:latest-scout > ./cves-recommendations.md || true")
                    }
                }
            }
        }

        stage("publish") {
            agent {
                docker {
                    image "${DOCKER_IMAGE__BUILD_DOCKERFILE}"
                    registryUrl "https://${NEXUS_DOCKER_GROUP_REGISTRY}"
                    registryCredentialsId "JENKINS_CI_NEXUS_CREDENTIALS"
                    alwaysPull true
                    reuseNode true
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }

            steps {
                withCredentials([string(credentialsId: "JENKINS_CI_JENKINS_CI_DOCKER_HUB_CREDENTIALS", variable: "JENKINS_CI_JENKINS_CI_DOCKER_HUB_CREDENTIALS")]) {
                        dir("${TYPE}/${NAME}/latest") {
                            sh("#!/bin/bash\n docker login -u \"${JENKINS_CI_JENKINS_CI_DOCKER_HUB_CREDENTIALS_USR}\" --password-stdin \"${JENKINS_CI_JENKINS_CI_DOCKER_HUB_CREDENTIALS_PSW}\"")
                            sh("#!/bin/bash\n bash build --daily")
                        }
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts "${TYPE}/${NAME}/latest/*.md"
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
