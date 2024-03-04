pipeline {
    agent any
    tools {
        jdk "java17"
        maven "M3"
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
    }
}
