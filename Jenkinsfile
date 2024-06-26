pipeline {
    agent any

    environment {
        DOCKER_IMAGE__ANALYSE_SONAR_SCANNER = "labocbz/analyse-sonar-scanner:latest"
        DOCKER_IMAGE__ANALYSE_DOCKER_IMAGE = "labocbz/analyse-docker-image:latest"
        DOCKER_IMAGE__BUILD_DOCKERFILE = "labocbz/build-dockerfile:latest"
        DOCKER_IMAGE__LINT_DOCKERFILE = "labocbz/lint-dockerfile:latest"
        DOCKER_IMAGE__LINT_SECRETS = "labocbz/lint-secrets:latest"
        DOCKER_IMAGE__LINT_MARKDOWN = "labocbz/lint-markdown:latest"

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
        stage("lint") {
            parallel {
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
                            sh("hadolint --ignore DL3001 --ignore DL3018 --ignore DL3013 --ignore DL3008 --ignore DL3009 --ignore DL3015 Dockerfile > ./hadolint.md")
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
                        sh("detect-secrets scan > ./${TYPE}/${NAME}/latest/detect-secrets-scan.md")
                        sh("detect-secrets audit .secrets.baseline > ./${TYPE}/${NAME}/latest/detect-secrets-audit.md")
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
                            sh("markdownlint './README.md' --disable MD013 > ./hadolint.md")
                        }
                    }
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
                    sh("sonar-scanner")
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
                    sh("bash build --test")
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
                dir("${TYPE}/${NAME}/latest") {
                    withCredentials([usernamePassword(credentialsId: "JENKINS_CI_DOCKER_HUB_CREDENTIALS", usernameVariable : "JENKINS_CI_DOCKER_HUB_CREDENTIALS_USR", passwordVariable: "JENKINS_CI_DOCKER_HUB_CREDENTIALS_PSW")]) {
                        sh("docker login -u \"${JENKINS_CI_DOCKER_HUB_CREDENTIALS_USR}\" -p \"${JENKINS_CI_DOCKER_HUB_CREDENTIALS_PSW}\"")
                        sh("bash build --scout")
                        sh("~/.docker/cli-plugins/docker-scout cves --exit-code --only-severity critical,high --format markdown local://local/${NAME}:latest-scout > ./cves-report.md || true")
                        sh("~/.docker/cli-plugins/docker-scout recommendations local://local/${NAME}:latest-scout > ./cves-recommendations.md || true")
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
                dir("${TYPE}/${NAME}/latest") {
                    withCredentials([usernamePassword(credentialsId: "JENKINS_CI_DOCKER_HUB_CREDENTIALS", usernameVariable : "JENKINS_CI_DOCKER_HUB_CREDENTIALS_USR", passwordVariable: "JENKINS_CI_DOCKER_HUB_CREDENTIALS_PSW")]) {
                        sh("docker login -u \"${JENKINS_CI_DOCKER_HUB_CREDENTIALS_USR}\" -p \"${JENKINS_CI_DOCKER_HUB_CREDENTIALS_PSW}\"")
                        sh("bash build --daily")
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
