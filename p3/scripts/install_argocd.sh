#!/bin/bash
set -euo pipefail

export KUBECONFIG="/home/vagrant/.kube/config"

# Quick sanity
kubectl get nodes >/dev/null

echo "Creating namespaces for ArgoCD and dev."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -


echo "Installing ArgoCD to argocd namespace"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl rollout status deploy/argocd-server -n argocd --timeout=300s || true
kubectl get pods -n argocd