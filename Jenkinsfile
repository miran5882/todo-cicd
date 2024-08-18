pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
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
        withCredentials([file(credentialsId: 'k8scred', variable: 'KUBECONFIG')]) {
          sh 'kubectl --kubeconfig=$KUBECONFIG apply -f kubernetes-manifests'
        }
      }
    }
  }
  post {
    failure {
      echo 'The Pipeline failed :('
    }
  }
}
