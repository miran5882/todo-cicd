pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    AWS_CREDENTIALS = credentials('aws') // This credential might not be needed anymore
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
          // Your build and push logic goes here
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        script {
          // Assuming kubectl is installed and configured on the Jenkins agent
          sh 'kubectl apply -f kubernetes-manifests'
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
