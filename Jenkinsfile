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
        sh 'sudo docker build -t miran77/todo-app:latest .'  // Build the image
        sh 'sudo docker push miran77/todo-app:latest'        // Push to Docker Hub
      }
    }
    stage('Deploy to EKS') {
      steps {
        sh 'sudo kubectl apply -f kubernetes-manifests'
      }
    }
  }
}
