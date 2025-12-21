#!/bin/bash
set -e

echo "[1/5] apt update and install dependencies"
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

echo "[2/5] Docker Installation"
sudo apt-get install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER" || true

# --- Docker daemon must be running ---
sudo systemctl enable --now docker

# --- Allow vagrant user to talk to Docker without sudo ---
if getent group docker >/dev/null 2>&1; then
  sudo usermod -aG docker vagrant
else
  sudo groupadd docker
  sudo usermod -aG docker vagrant
fi

# --- Create kube dir for vagrant user ---
sudo -u vagrant mkdir -p /home/vagrant/.kube
sudo -u vagrant chmod 700 /home/vagrant/.kube

echo "[INFO] Docker group applied. IMPORTANT: you must re-login once for group to take effect."

echo "[3/5] kubectl Installation"
KUBECTL_VERSION="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
sudo install -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

echo "[4/5] k3d Installation"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "[5/5] Verify installations"
docker --version
kubectl version --client=true
k3d version

if [ $? -eq 0 ]; then
  echo "All tools installed successfully."
else
  echo "There was an error installing the tools."
  exit 1
fi
