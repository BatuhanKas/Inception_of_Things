#!/bin/bash

set -e

echo "Updating system..."
apt-get update -y
apt-get upgrade -y

echo "Installing required packages..."
apt-get install -y curl ca-certificates apt-transport-https

echo "Installing k3s SERVER..."
curl -sfL https://get.k3s.io | sh -s - server \
  --node-ip=192.168.56.110 \
  --write-kubeconfig-mode=644

echo "Enabling k3s service..."
systemctl enable k3s
systemctl start k3s

echo "Installing kubectl (a.k.a. k3s)..."
ln -sf /usr/local/bin/k3s /usr/local/bin/kubectl

echo "k3s Service Installation Completed!"