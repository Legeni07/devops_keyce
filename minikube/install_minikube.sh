#!/bin/bash

# Update package lists
sudo apt-get update && sudo apt-get upgrade -y

# Install necessary dependencies
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    wget \
    socat \
    conntrack

# Install libvirt and KVM
sudo apt-get install -y \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    virtinst \
    libguestfs-tools

# Install Docker
# Remove any existing Docker installations
sudo apt-get remove docker docker-engine docker.io containerd runc

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update package lists again
sudo apt-get update

# Install Docker CE
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add current user to docker group
sudo usermod -aG docker $USER

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install Minikube
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube

# Install kubectl
# Get the latest stable version
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
wget https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

# Enable bridge networking
echo '1' | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables

# Print IP address (adjust interface name if needed)
echo "For this Stack, you will use $(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"

# Note for Minikube startup
echo "Connect through ssh on the VM and then run 'minikube start --driver=none'"
echo "Don't run the command as root user or using any sudo command"
