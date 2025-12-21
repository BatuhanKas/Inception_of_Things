#!/bin/bash
set -e
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# K3s ready bekle
for i in $(seq 1 60); do
  kubectl get nodes >/dev/null 2>&1 && break
  sleep 1
done

kubectl apply -f /vagrant/manifests/app1.yaml
kubectl apply -f /vagrant/manifests/app2.yaml
kubectl apply -f /vagrant/manifests/app3.yaml
kubectl apply -f /vagrant/manifests/ingress.yaml
