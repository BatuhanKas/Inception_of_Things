#!/bin/bash
set -euo pipefail

CLUSTER_NAME="bkasS-cluster"
KUBECONFIG_PATH="/home/vagrant/.kube/config"

echo "[INFO] Ensuring docker daemon is running..."
sudo systemctl enable --now docker

echo "[INFO] Deleting old cluster if exists..."
sudo k3d cluster delete "$CLUSTER_NAME" >/dev/null 2>&1 || true

echo "[INFO] Creating k3d cluster with port mapping 8888->8888..."
sudo k3d cluster create "$CLUSTER_NAME" \
  --agents 1 \
  -p "8888:8888@loadbalancer"

echo "[INFO] Writing kubeconfig for vagrant user..."
sudo -u vagrant mkdir -p /home/vagrant/.kube
sudo k3d kubeconfig get "$CLUSTER_NAME" > "$KUBECONFIG_PATH"

# Fix common endpoint issue: 0.0.0.0 is not usable from kubectl client
sudo sed -i 's#https://0.0.0.0:#https://127.0.0.1:#' "$KUBECONFIG_PATH"
sudo chown vagrant:vagrant "$KUBECONFIG_PATH"
sudo chmod 600 "$KUBECONFIG_PATH"

echo "[INFO] Verifying kubectl can reach the cluster..."
sudo -u vagrant bash -lc "export KUBECONFIG=$KUBECONFIG_PATH && kubectl get nodes -o wide"

echo "[OK] Cluster is ready and kubeconfig is set for vagrant user."
