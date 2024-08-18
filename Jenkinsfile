pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        GITHUB_CREDENTIALS = credentials('github')
        KUBERNETES_CREDENTIALS = credentials('k8scred')
        CLUSTER_NAME = 'my-cluster'
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/miran5882/todo-cicd.git'
            }
        }
        
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t miran77/todo-app:latest .'
                    
                    // Login to DockerHub
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    
                    // Push the image
                    sh 'docker push miran77/todo-app:latest'
                }
            }
        }
        
        stage('Deploy to EKS') {
            steps {
                script {
                    // Configure kubectl
                    sh """
                    aws eks --region us-east-1 update-kubeconfig --name ${CLUSTER_NAME}
                    kubectl get nodes
                    """
                    
                    // Apply deployment and service YAML files
                    sh '''
                    kubectl apply -f kubernetes-manifests/deployment.yaml
                    kubectl apply -f kubernetes-manifests/service.yaml
                    '''
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
