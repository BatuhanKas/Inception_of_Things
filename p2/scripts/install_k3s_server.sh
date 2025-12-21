#!/bin/bash
set -e

apt-get update -y
apt-get install -y curl ca-certificates

SERVER_IP="192.168.56.110"

curl -sfL https://get.k3s.io | sh -s - server \
  --node-ip "${SERVER_IP}" \
  --advertise-address "${SERVER_IP}" \
  --bind-address "${SERVER_IP}" \
  --write-kubeconfig-mode 644

echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> /home/vagrant/.bashrc
