pipeline {

    agent {
        label 'My-Jenkins-Agent'
    }
    // agent any

    environment {
        APP_NAME = "devops-003-pipeline-aws"
        RELEASE = "1.0"
        DOCKER_USER = "mimaraslan"
        DOCKER_LOGIN = "dockerhub"
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}.${BUILD_NUMBER}"
        JENKINS_API_TOKEN = credentials ("JENKINS_API_TOKEN")
       // GITOPS_TOKEN = "gitops_token"
    }
    tools {
        jdk 'JDK21'
        maven 'Maven3'
    }
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from SCM') {
            steps {
                //   checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/mimaraslan/devops-003-pipeline-aws']])
                git branch: 'master', credentialsId: 'github', url: 'https://github.com/mimaraslan/devops-003-pipeline-aws'
            }
        }
        stage('Build Maven') {
            steps {
                //  sh 'mvn clean install'
                //  bat 'mvn clean install'

               sh 'mvn clean package'
               // bat 'mvn clean package'

            }
        }

        /*
        stage('Test Application') {
            steps {
                sh 'mvn test'
                //  bat 'mvn test'
            }
        }
        stage("SonarQube Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }
        }
        */


 /*
       stage("Quality Gate"){
           steps {
               script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }
*/

        stage('Build & Push Docker Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_LOGIN) {
                        docker_image = docker.build "${IMAGE_NAME}"
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push("latest")
                    }
                }
            }
        }


        stage("Trivy Scan") {
            steps {
                script {
                    sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image mimaraslan/devops-003-pipeline-aws:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
                }
            }
        }


        stage ('Cleanup Artifacts') {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                    //TODO docker volume prune
                }
            }
        }



     stage("Trigger CD Pipeline") {
            steps {
                script {
//                    sh "curl -v -k --user mimaraslan:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-34-200-201-217.compute-1.amazonaws.com:8080/job/gitops-devops-003-pipeline-aws/buildWithParameters?token=${GITOPS_TOKEN}'"
                      sh "curl -v -k --user mimaraslan:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-34-200-201-217.compute-1.amazonaws.com:8080/job/gitops-devops-003-pipeline-aws/build?token=MyGitHubTokenForAWSGitOps'"
                  }
            }
       }



    }
}
