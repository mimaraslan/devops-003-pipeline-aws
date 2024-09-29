pipeline {
    // agent {label 'My-Jenkins-Agent'}
    agent any
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



        /*
        stage('Docker Image') {
           steps {
               //  sh 'docker build  -t mimaraslan/my-application:latest  .'
                  bat 'docker build  -t mimaraslan/my-application:latest  .'
           }
        }


        stage('Docker Image to DockerHub') {
            steps {
                script{
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {

                        //  sh 'echo docker login -u mimaraslan -p DOCKERHUB_TOKEN'
                        // bat 'echo docker login -u mimaraslan -p DOCKERHUB_TOKEN'

                        // sh 'echo docker login -u mimaraslan -p ${dockerhub}'
                          bat 'echo docker login -u mimaraslan -p ${dockerhub}'

                        // sh 'docker image push  mimaraslan/my-application:latest'
                           bat 'docker image push  mimaraslan/my-application:latest'
                    }
                }
            }
        }


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
