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
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        sh 'docker build -t miran77/todo-app:${BUILD_NUMBER} .'
        sh 'docker push miran77/todo-app:${BUILD_NUMBER}'
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
      sh 'docker logout'
    }
  }
}
