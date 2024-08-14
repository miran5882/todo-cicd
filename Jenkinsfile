pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/miran5882/todo-cicd.git', branch: 'main'
      }
    }
    stage('Build and Push Docker Image') {
      steps {
        script {
          sh 'docker --version'  // Check Docker installation
          sh 'which docker'      // Check Docker path
          
          // Remove any existing Docker config to ensure clean login
          sh 'rm -f $HOME/.docker/config.json || true'
          
          // Login to Docker Hub
          sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
          
          // Build and push the image
          def imageName = "miran77/todo-app:${BUILD_NUMBER}"
          sh "docker build -t ${imageName} ."
          sh "docker push ${imageName}"
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
    always {
      sh 'docker logout || true'
      sh 'rm -f $HOME/.docker/config.json || true'
    }
  }
}
