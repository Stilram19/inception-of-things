#!/bin/bash

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

# applying argocd manifest
kubectl apply -n argocd -f ../confs/application.yaml
