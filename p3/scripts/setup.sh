#!/bin/bash

# create the cluster only if it hasn't been created yet 
if ! k3d cluster list | grep -q "iotCluster"; then
    echo "creating K3D cluster..."
    k3d cluster create iotCluster
else
    echo "cluster iotCluster already exists, skipping..."
fi

# create namespaces
for ns in argocd dev; do
    if ! kubectl get namespace $ns &> /dev/null; then
        echo "creating namespace $ns..."
        kubectl create namespace $ns
    else
        echo "namespace $ns already exists, skipping..."
    fi
done

# install argocd (by applying the install.yaml manifest)
# registering new CRDs to teach kubernetes about new resource types like (kind: application)
# creating argocd pods (to make argocd run inside the cluster)
if ! kubectl get deployment argocd-server -n argocd &> /dev/null; then
    echo "installing argocd..."
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
else
    echo "argocd already installed, skipping..."
fi

# wait for argocd to be ready
echo "waiting for argocd to be ready..."
kubectl wait --for=condition=available deployment/argocd-server \
    -n argocd \
    --timeout=120s
