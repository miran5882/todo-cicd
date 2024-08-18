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
          // ... your build and push logic ...
        }
      }
    }
    stage('Deploy to Kubernetes') {
      agent none
      kubernetes {
        cloud 'k8s'
        namespace 'dev' // Replace with your namespace
        container 'kubectl'
        script {
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
