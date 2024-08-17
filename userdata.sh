#!/bin/bash
sudo set -e

# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install necessary tools
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins

# Install Jenkins
sudo apt-get update
sudo apt install openjdk-17-jre-headless
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
sudo echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl start jenkins 
sudo systemctl enable jenkins

# Install kubectl
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install eksctl
sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Install AWS CLI
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install -y unzip
sudo unzip awscliv2.zip
sudo ./aws/install

# Configure Jenkins to use Docker without sudo
sudo echo 'jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker' | EDITOR='tee -a' visudo

# Set up Docker config for Jenkins
sudo mkdir -p /var/lib/jenkins/.docker
sudo echo '{"credsStore": "ecr-login"}' > /var/lib/jenkins/.docker/config.json
sudo chown -R jenkins:jenkins /var/lib/jenkins/.docker
sudo chmod 600 /var/lib/jenkins/.docker/config.json

# Install Docker pipeline plugin for Jenkins
sudo jenkins-plugin-cli --plugins docker-workflow:563.vd5d2e5c4007f

# Restart Jenkins to apply changes
sudo systemctl restart jenkins

# Print the initial Jenkins admin password
echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Setup complete. Please ensure you configure Jenkins security and change the admin password."
