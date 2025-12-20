#!/bin/bash

set -e

echo "Updating system..."
apt-get update -y
apt-get upgrade -y

echo "Installing required packages..."
apt-get install -y curl ca-certificates net-tools

SERVER_IP="192.168.56.110"
WORKER_IP="192.168.56.111"
TOKEN_FILE="/vagrant/token"

if [ ! -f "$TOKEN_FILE" ]; then
  echo "Token file not found at $TOKEN_FILE !"
  echo "Make sure the server node is up and has created the token !"
  exit 1
fi

NODE_TOKEN=$(cat $TOKEN_FILE)

echo "Installing k3s AGENT (worker)..."
curl -sfL https://get.k3s.io | K3S_URL="https://${SERVER_IP}:6443" K3S_TOKEN="$NODE_TOKEN" sh -s - \
  --node-ip="${WORKER_IP}"

echo "Enabling k3s-Agent Service..."
systemctl enable k3s-agent
systemctl start k3s-agent

echo "k3s WORKER installation completed!"