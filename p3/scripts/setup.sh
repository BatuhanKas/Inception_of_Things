#!/bin/bash
set -e

echo "[1] Install dependencies"
apt-get update -y
apt-get install -y curl ca-certificates gnupg lsb-release docker.io

systemctl enable docker
systemctl start docker
usermod -aG docker vagrant

echo "[2] Install kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" # Download kubectl binary amd64
chmod +x kubectl
mv kubectl /usr/local/bin/

echo "[3] Install k3d"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "[4] Create k3d cluster (deterministic)"
k3d cluster delete bkasS-cluster || true
k3d cluster create bkasS-cluster --agents 1

echo "[5] Configure kubeconfig"
mkdir -p /home/vagrant/.kube
k3d kubeconfig get bkasS-cluster > /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
chmod 600 /home/vagrant/.kube/config

sed -i 's#https://0.0.0.0:#https://127.0.0.1:#' /home/vagrant/.kube/config

echo "[6] Install ArgoCD"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "[7] Wait for Argo CD to be ready"
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s

echo "[8] Deploy GitOps application"
kubectl apply -f /vagrant/bootstrap/application.yaml