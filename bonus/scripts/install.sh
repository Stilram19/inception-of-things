#!/bin/bash

# install Docker if not installed yet
if ! command -v docker &> /dev/null; then
    echo "installing docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
else
    echo "docker already installed: $(docker --version)"
fi

# install Kubectl if not installed yet
if ! command -v kubectl &> /dev/null; then
    echo "installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
else
    echo "kubectl already installed: $(kubectl version --client)"
fi

# install K3d if not installed yet
if ! command -v k3d &> /dev/null; then
    echo "installing k3d..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "k3d already installed: $(k3d version)"
fi

echo "all tools ready!"
