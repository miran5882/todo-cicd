pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        GITHUB_CREDENTIALS = credentials('github')
        KUBERNETES_CREDENTIALS = credentials('k8scred')
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
                    sh 'docker build -t miran77/todo-app:${BUILD_NUMBER} .'
                    
                    // Login to DockerHub
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    
                    // Push the image
                    sh 'docker push miran77/todo-app:${BUILD_NUMBER}'
                }
            }
        }
        
        stage('Deploy to EKS') {
            steps {
                script {
                    // Configure kubectl (assuming AWS EKS)
                    sh 'aws eks get-token --cluster-name your-cluster-name | kubectl apply -f -'
                    
                    // Update the deployment YAML with the new image tag
                    sh """
                    sed -i 's|image: miran77/todo-app:.*|image: miran77/todo-app:${BUILD_NUMBER}|' kubernetes-manifests/deployment.yaml
                    """
                    
                    // Apply both deployment and service YAML files
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
