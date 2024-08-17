#!/bin/bash
set -e

# Update the system
apt-get update
apt-get upgrade -y

# Install necessary tools
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
usermod -aG docker jenkins

# Install Jenkins
# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install -y openjdk-11-jdk jenkins
systemctl start jenkins
systemctl enable jenkins

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt-get install -y unzip
unzip awscliv2.zip
./aws/install

# Configure Jenkins to use Docker without sudo
echo 'jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker' | EDITOR='tee -a' visudo

# Set up Docker config for Jenkins
mkdir -p /var/lib/jenkins/.docker
echo '{"credsStore": "ecr-login"}' > /var/lib/jenkins/.docker/config.json
chown -R jenkins:jenkins /var/lib/jenkins/.docker
chmod 600 /var/lib/jenkins/.docker/config.json

# Install Docker pipeline plugin for Jenkins
jenkins-plugin-cli --plugins docker-workflow:563.vd5d2e5c4007f

# Restart Jenkins to apply changes
systemctl restart jenkins

# Print the initial Jenkins admin password
echo "Jenkins initial admin password:"
cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Setup complete. Please ensure you configure Jenkins security and change the admin password."
