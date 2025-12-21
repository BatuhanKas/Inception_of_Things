#!/bin/bash
set -e

SERVER_IP="192.168.56.110"
WORKER_IP="192.168.56.111"

# Token gelene kadar bekle
for i in $(seq 1 60); do
  [ -f /vagrant/node-token ] && break
  sleep 1
done

if [ ! -f /vagrant/node-token ]; then
  echo "node-token not found in /vagrant/node-token"
  exit 1
fi

TOKEN="$(cat /vagrant/node-token)"

curl -sfL https://get.k3s.io | \
  K3S_URL="https://${SERVER_IP}:6443" \
  K3S_TOKEN="${TOKEN}" \
  sh -s - agent --node-ip "${WORKER_IP}"
