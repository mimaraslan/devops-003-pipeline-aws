pipeline {

    agent {label 'My-Jenkins-Agent'}

   // agent any

environment {
        APP_NAME="devops-003-pipeline-aws"
        RELEASE="1.0"
        DOCKER_USER="mimaraslan"
        DOCKER_LOGIN="dockerhub"
        IMAGE_NAME="${DOCKER_USER}"+"/"+"${APP_NAME}"
        IMAGE_TAG="${RELEASE}.${BUILD_NUMBER}"
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
                //  bat 'mvn clean package'
            }
        }

        stage('Test Application') {
            steps {
                sh 'mvn test'
                //  bat 'mvn test'
            }
        }


       stage("SonarQube Analysis"){
           steps {
	           script {
		           withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                      sh "mvn sonar:sonar"
		           }
	           }
           }
       }


       stage("Quality Gate"){
           steps {
               script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }


/*
        stage('Docker Image') {
           steps {
               //  sh 'docker build  -t mimaraslan/my-application:latest  .'
                  bat 'docker build  -t mimaraslan/my-application:latest  .'
           }
        }
*/

        stage('Build & Push Docker Image to DockerHub') {
            steps {
                script{


                    docker.withRegistry ('', DOCKER_LOGIN) {
                           docker_image = docker.build "${IMAGE_NAME}"
                    }


                      docker.withRegistry ('', DOCKER_LOGIN) {
                             docker_image = docker.push ("${IMAGE_TAG}")

                             docker_image = docker.push ('latest')
                              // sh 'docker image push  mimaraslan/my-application:latest'

                      }


                         // sh 'echo docker login -u mimaraslan -p ${dockerhub}'

                }
            }
        }



/*
        stage('Deploy to Kubernetes'){
            steps{
                kubernetesDeploy (configs: 'deployment-service.yml', kubeconfigId: 'kubernetes')
            }
        }


       stage('Docker Image to Clean') {
           steps {
               //   sh 'docker rmi mimaraslan/my-application:latest'
               //  bat 'docker rmi mimaraslan/my-application:latest'

               // sh 'docker image prune -f'
                bat 'docker image prune -f'
           }
       }
*/
    }
}
