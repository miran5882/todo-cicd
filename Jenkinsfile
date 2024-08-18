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
      steps {
        kubernetes {
          cloud 'k8s'
          namespace 'dev' // Replace with your namespace
          yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: kubectl
                image: bitnami/kubectl:latest
                command:
                - cat
                tty: true
          '''
        }
        container('kubectl') {
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
