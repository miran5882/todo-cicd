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
        script {
          docker.build("miran77/todo-app:${BUILD_ID}", './')
          docker.push("miran77/todo-app:${BUILD_ID}")
        }
      }
    }
    stage('Deploy to EKS') {
      steps {
        sh 'kubectl apply -f kubernetes-manifests'
      }
    }
  }
}

