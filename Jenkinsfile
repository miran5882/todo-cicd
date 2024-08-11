pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/miran5882/todo-cicd.git', branch: 'main'
      }
    }
    stage('Build and Push Docker Image') {
      steps {
        sh 'docker build -t miran77/todo-app:${BUILD_ID} .'  // Build the image
        sh 'docker push miran77/todo-app:${BUILD_ID}'        // Push to Docker Hub
      }
    }
    stage('Deploy to EKS') {
      steps {
        sh 'kubectl apply -f kubernetes-manifests'
      }
    }
  }
}
