#!/bin/bash
set -e

echo "[1] Install dependencies"
apt-get update -y
apt-get install -y curl ca-certificates gnupg lsb-release docker.io

systemctl enable docker
systemctl start docker
usermod -aG docker vagrant

echo "[2] Install k3d"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "[3] Create k3d cluster (deterministic)"
k3d cluster delete bkas-cluster || true

k3d cluster create bkas-cluster \
  --agents 1 \
  -p "8888:8888@loadbalancer"

echo "[4] Configure kubeconfig"
mkdir -p /home/vagrant/.kube
k3d kubeconfig get bkas-cluster > /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
chmod 600 /home/vagrant/.kube/config

sed -i 's#https://0.0.0.0:#https://127.0.0.1:#' /home/vagrant/.kube/config

echo "[5] Install ArgoCD"
kubectl create namespace argocd || true
kubectl create namespace dev || true

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "[6] Wait for ArgoCD"
kubectl rollout status deployment argocd-server -n argocd --timeout=300s

echo "[7] Deploy GitOps application"
kubectl apply -f /vagrant/bootstrap/application.yaml

echo "[8] Port-forward (guaranteed access)"
nohup kubectl -n dev port-forward svc/wil-service 8888:8888 --address 0.0.0.0 >/tmp/pf.log 2>&1 &
