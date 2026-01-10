#!/bin/bash

set -e

echo "Updating system..."
apt-get update -y

echo "Installing required packages..."
apt-get install -y curl ca-certificates net-tools

echo "Installing k3s SERVER..."
curl -sfL https://get.k3s.io | sh -s - server \
  --node-ip=192.168.56.110 \
  --write-kubeconfig-mode=644

echo "Enabling k3s service..."
systemctl enable k3s
systemctl start k3s

echo "Waiting for k3s to be ready..."
until kubectl get nodes &>/dev/null; do
  echo "Waiting for k3s..."
  sleep 2
done

echo "Creating kubectl symlink to k3s binary..."
ln -sf /usr/local/bin/k3s /usr/local/bin/kubectl

echo 'export PATH=$PATH:/usr/sbin' >> /home/vagrant/.bashrc

echo "k3s Service Installation Completed!"