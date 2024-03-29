pipeline {
    agent any
    tools {
        jdk "java17"
        maven "M3"
    }
    environment {
        // docker config
        // docker config
        APP_NAME = 'complete-production-boweplus'
        RELEASE = "1.0.0"
        DOCKER_USER = "ibrahimaisi"
        DOCKER_PASS = "dockerhub"
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"

        // Nexus config
        def mvn = tool 'M3'

        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "172.18.0.4:8081"
        GROUP_ID = "com.bowe"
        NEXUS_REPOSITORY = "boweplus-repos"
        NEXUS_CREDENTIAL_ID = "nexus-credentials"
        ARTIFACT_VERSION = "${BUILD_NUMBER}"
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
        stage("SONAR") {
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
        stage("DOCKER") {
            steps {
                echo "==================DOCKER================"
                // script {
                    // docker.withRegistry("", DOCKER_PASS) {
                        // docker_image = docker.build "${IMAGE_NAME}"
                    // }
                    // docker.withRegistry("", DOCKER_PASS) {
                        // docker_image.push("${IMAGE_TAG}")
                        // docker_image.push("latest")
                        // echo "=================== Pushed ===================="
                    // }
                // }
            }
        }
        stage("NEXUS") {
            steps {
                echo "====================== NEXUS PUBLISHING =================="
                script {
                    pom = readMavenPom file: "pom.xml";
                    fileByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${fileByGlob[0].name} ${fileByGlob[0].path} ${fileByGlob[0].directory} ${fileByGlob[0].length} ${fileByGlob[0].lastModified}"
                    artifactPath = fileByGlob[0].path;
                    artifactExists = fileExists artifactPath;

                    if(artifactExists){
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: ARTIFACT_VERSION,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [
                                    artifactId: pom.artifactId,
                                    classifier: '',
                                    file: artifactPath,
                                    type: pom.packaging
                                ]
                            ]
                        );
                    }
                    else{
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
    }
}

