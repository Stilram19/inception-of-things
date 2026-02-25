#!/bin/bash

# create the cluster only if it hasn't been created yet 
if ! k3d cluster list | grep -q "iotCluster"; then
    echo "creating K3D cluster..."
    k3d cluster create iotCluster
else
    echo "cluster iotCluster already exists, skipping..."
fi

# create namespaces
for ns in argocd dev gitlab; do
    if ! kubectl get namespace $ns &> /dev/null; then
        echo "creating namespace $ns..."
        kubectl create namespace $ns
    else
        echo "namespace $ns already exists, skipping..."
    fi
done

# applying gitlab manifests
echo "deploying gitlab resources..."
kubectl apply -f ../confs/gitlab-pvc.yaml
kubectl apply -f ../confs/gitlab-secret.yaml
kubectl apply -f ../confs/gitlab-deployment.yaml
kubectl apply -f ../confs/gitlab-service.yaml
