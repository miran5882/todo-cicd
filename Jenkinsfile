pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    AWS_CREDENTIALS = credentials('aws')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build and Push Docker Image') {
      steps {
        script {
          try {
            sh 'docker --version'
            sh 'which docker'
            
            // Login to Docker Hub
            withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
              sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
            }
            
            // Build and push the image
            def imageName = "miran77/todo-app:latest"
            sh "docker build -t ${imageName} ."
            sh "docker push ${imageName}"
            
            // Logout from Docker Hub
            sh 'docker logout'
          } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            error("Failed to build or push Docker image: ${e.message}")
          }
        }
      }
    }
    stage('Deploy to EKS') {
      steps {
        script {
          try {
            withCredentials([
              file(credentialsId: 'k8scred', variable: 'KUBECONFIG'),
              [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws']
            ]) {
              // Configure AWS CLI
              sh 'aws --version'
              sh 'aws sts get-caller-identity'
              
              // Update kubeconfig
              sh 'aws eks --region us-east-1 update-kubeconfig --name my-cluster'
              
              // Apply Kubernetes manifests
              sh 'kubectl apply -f kubernetes-manifests'
            }
          } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            error("Failed to deploy to EKS: ${e.message}")
          }
        }
      }
    }
  }
  post {
    success {
      echo 'The Pipeline succeeded!'
    }
    failure {
      echo 'The Pipeline failed :('
    }
  }
}
