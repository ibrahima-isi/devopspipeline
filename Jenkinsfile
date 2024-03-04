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
    }
}
