CLUSTER_NAME=bkasS

all: cluster argocd deploy

cluster:
	k3d cluster create $(CLUSTER_NAME)
	kubectl create namespace argocd
	kubectl create namespace dev
	@echo "Cluster '$(CLUSTER_NAME)' created with namespaces 'argocd' and 'dev'."

argocd:
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@echo "Argo CD installed in namespace 'argocd'."

deploy:
	kubectl apply -f ./confs/application.yaml -n argocd
	@echo "Application deployed via Argo CD."

clean:
	k3d cluster delete $(CLUSTER_NAME)
	@echo "Cluster '$(CLUSTER_NAME)' deleted."

re: clean all

r: re

port-forward-argocd:
	kubectl port-forward -n argocd svc/argocd-server 8081:443 --address 0.0.0.0
	@echo "Port forwarding for Argo CD started on http://localhost:8081"

port-forward-host:
	kubectl port-forward -n dev svc/wil-service 8888:8888 --address 0.0.0.0
	@echo "Port forwarding for host service started on http://localhost:8888"

argocd-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

request:
	curl http://localhost:8888

.PHONY: all cluster argocd clean re port-forward-argocd port-forward-host argocd-password request