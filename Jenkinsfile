pipeline {
    agent any
    tools {
        jdk "java17"
        maven "M3"
    }
    environment {
        APP_NAME = 'complete-production-boweplus'
        RELEASE = "1.0.0"
        DOCKER_USER = "ibrahimaisi"
        DOCKER_PASS = "dockerhub"
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }
    stages {
        stage("CLEANUP WORKSPACE") {
            steps {
                echo "==================CLEANING================"
                cleanWs()
            }
        }
        stage("CHECKOUT FROM SCM") {
            steps {
                echo "==================CHECKING FROM GITHUB================"
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/ibrahima-isi/devopspipeline'
            }
        }
        stage("BUILD WITH MAVEN"){
            steps {
                echo "==================BUILDING================"
                sh "mvn clean package"
            }
        }
        stage("TEST STAGE"){
            steps {
                sh "mvn test"
            }
        }
        stage("SONAR ANALYSIS") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    echo "==================SONAR ANALYSING================"
                    sh "mvn sonar:sonar"
                }
            }
        }
        stage("QUALITY GATES") {
            steps {
                script {
                    echo "==================QUALITY GATES AWAIT================"
                    // waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonar'
                }
            }
        }
        stage("BUILD PUBLISH IMAGE") {
            steps {
                echo "==================PUBLISHING TO DOCKER HUB================"
                script {
                    docker.withRegistry("", DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }
                    docker.withRegistry("", DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push("latest")
                        echo "=================== Pushed ===================="
                    }
                }
            }
        }
    }
}
