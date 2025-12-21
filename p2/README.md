# Part 2: K3s with Application Deployments and Ingress

This project deploys a K3s Kubernetes cluster with multiple applications, services, and ingress-based routing using hostname configuration.

## 📋 Table of Contents

- [Architecture](#-architecture)
- [Installation](#-installation)
- [Applications](#-applications)
- [Ingress Routing](#-ingress-routing)
- [Usage](#-usage)
- [Troubleshooting](#-troubleshooting)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│              K3s Cluster with Applications              │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │              bkasS (Server Node)                 │   │
│  │           IP: 192.168.56.110                     │   │
│  │           Role: Master + Worker                  │   │
│  └──────────────────────────────────────────────────┘   │
│                         │                               │
│         ┌───────────────┼───────────────┐               │
│         │               │               │               │
│    ┌────▼────┐    ┌────▼────┐    ┌────▼────┐            │
│    │  App1   │    │  App2   │    │  App3   │            │
│    │ (1 pod) │    │(3 pods) │    │ (1 pod) │            │
│    └────┬────┘    └────┬────┘    └────┬────┘            │
│         │              │              │                 │
│    ┌────▼────┐    ┌────▼────┐    ┌────▼────┐            │
│    │ Service │    │ Service │    │ Service │            │
│    │  :80    │    │  :80    │    │  :80    │            │
│    └────┬────┘    └────┬────┘    └────┬────┘            │
│         │              │              │                 │
│         └──────────────┴──────────────┘                 │
│                        │                                │
│              ┌─────────▼─────────┐                      │
│              │  Traefik Ingress   │                      │
│              │   (Port 80/443)   │                      │
│              └───────────────────┘                      │
│                                                         │
│  Routing:                                               │
│  • app1.com      → app1-service → App1                  │
│  • app2.com      → app2-service → App2 (3 replicas)     │
│  • app3.com      → app3-service → App3                  │
│  • default/IP    → app3-service → App3 (fallback)       │
└─────────────────────────────────────────────────────────┘
```

## 🛠️ Requirements

### Software Requirements

- [Vagrant](https://www.vagrantup.com/downloads) >= 2.0
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) >= 6.0
- Minimum 2GB free RAM
- Minimum 10GB free disk space

### System Requirements

- **macOS**: Intel or Apple Silicon (ARM64)
- **Linux**: x86_64 or ARM64
- **Windows**: WSL2 recommended

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repo-url>
cd iot/p2
```

### 2. Start the Cluster

```bash
# Start the VM and K3s cluster
vagrant up

# Wait for installation to complete (3-5 minutes)
```

### 3. Verify Installation

```bash
# Check cluster status
vagrant ssh bkasS -c "kubectl get nodes"

# Check pods status
vagrant ssh bkasS -c "kubectl get pods"

# Check services
vagrant ssh bkasS -c "kubectl get svc"

# Check ingress
vagrant ssh bkasS -c "kubectl get ingress"
```

**Expected Output:**

```
NAME                           READY   STATUS    RESTARTS   AGE
app1-deployment-xxxxxx         1/1     Running   0          2m
app2-deployment-xxxxxx         1/1     Running   0          2m
app2-deployment-xxxxxx         1/1     Running   0          2m
app2-deployment-xxxxxx         1/1     Running   0          2m
app3-deployment-xxxxxx         1/1     Running   0          2m
```

## 📱 Applications

### App 1: Single Instance Application

- **Image**: `hashicorp/http-echo:latest`
- **Replicas**: 1
- **Port**: 5678
- **Message**: "Hello from App 1"
- **Access**: http://app1.com

### App 2: High Availability Application

- **Image**: `hashicorp/http-echo:latest`
- **Replicas**: 3 (load balanced)
- **Port**: 5678
- **Message**: "Hello from App 2"
- **Access**: http://app2.com

### App 3: Default/Fallback Application

- **Image**: `hashicorp/http-echo:latest`
- **Replicas**: 1
- **Port**: 5678
- **Message**: "Hello from App 3"
- **Access**: http://app3.com or http://192.168.56.110

## 🌐 Ingress Routing

The project uses **Traefik** as the Ingress Controller (comes with K3s by default).

### Routing Rules

| Hostname    | Service       | Pods | Behavior                          |
|-------------|---------------|------|-----------------------------------|
| app1.com    | app1-service  | 1    | Routes to App 1                   |
| app2.com    | app2-service  | 3    | Load balances across 3 App 2 pods |
| app3.com    | app3-service  | 1    | Routes to App 3                   |
| **(default)** | app3-service  | 1    | Fallback for unmatched requests   |

### Ingress Configuration

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: apps-ingress
spec:
  rules:
    - host: app1.com
      # Routes to app1-service
    - host: app2.com
      # Routes to app2-service
    - host: # default host app3.com
      # Routes to app3-service
```

## 💻 Usage

### Configure /etc/hosts

To access applications via hostname, add entries to your `/etc/hosts` file:

```bash
# macOS/Linux
sudo nano /etc/hosts

# Add these lines:
192.168.56.110 app1.com
192.168.56.110 app2.com
192.168.56.110 app3.com
```

**Windows**: Edit `C:\Windows\System32\drivers\etc\hosts` as Administrator

### Access Applications

Open your browser and navigate to:

- **App 1**: http://app1.com
- **App 2**: http://app2.com (load balanced across 3 pods)
- **App 3**: http://app3.com or http://192.168.56.110

### Testing Load Balancing

```bash
# Test App 2 load balancing (3 replicas)
for i in {1..10}; do
  curl -H "Host: app2.com" http://192.168.56.110
done
```

### Kubernetes Commands

```bash
# SSH into the cluster
vagrant ssh bkasS

# Get all resources
kubectl get all

# Get pods with labels
kubectl get pods --show-labels

# Get detailed pod info
kubectl describe pod <pod-name>

# View pod logs
kubectl logs <pod-name>

# Get ingress details
kubectl describe ingress apps-ingress

# Scale app2 replicas
kubectl scale deployment app2-deployment --replicas=5

# Delete and recreate resources
kubectl delete -f /vagrant/manifests/
kubectl apply -f /vagrant/manifests/
```

## 🗂️ Project Structure

```
p2/
├── Vagrantfile                    # VM configuration
├── scripts/
│   └── install_k3s_server.sh      # K3s installation script
├── manifests/
│   ├── app1.yaml                  # App 1: Deployment + Service
│   ├── app2.yaml                  # App 2: Deployment + Service (3 replicas)
│   ├── app3.yaml                  # App 3: Deployment + Service
│   └── ingress.yaml               # Ingress routing rules
└── README.md                      # This file
```

## 🔧 Manifest Files

### Deployment (app1.yaml, app2.yaml, app3.yaml)

Each application has:
- **Deployment**: Manages pod replicas
- **Service**: Exposes pods internally (ClusterIP)
- **Labels**: Links deployments, services, and pods

### Ingress (ingress.yaml)

- Routes external HTTP traffic based on hostname
- Configured with Traefik (K3s default)
- Supports default backend for fallback routing

## 🐛 Troubleshooting

### Issue: 502 Bad Gateway

**Cause**: Port mismatch between container and service

**Solution**: Verify `containerPort` matches `targetPort`:

```yaml
containers:
  - containerPort: 5678  # Must match
service:
  ports:
    - port: 80
      targetPort: 5678   # Must match containerPort
```

### Issue: 404 Not Found on app3.com

**Cause**: Ingress needs explicit host rule for app3

**Solution**: Ensure `app3.com` is in ingress rules AND defaultBackend is set

### Issue: Pods Not Starting

```bash
# Check pod status
kubectl get pods

# View pod events
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

### Issue: Cannot Access via Hostname

**Verify /etc/hosts**:
```bash
cat /etc/hosts | grep 192.168.56.110
```

**Test with Host header**:
```bash
curl -H "Host: app1.com" http://192.168.56.110
```

### Issue: Ingress Not Working

```bash
# Check ingress status
kubectl get ingress
kubectl describe ingress apps-ingress

# Check Traefik pods
kubectl get pods -n kube-system | grep traefik

# View Traefik logs
kubectl logs -n kube-system -l app.kubernetes.io/name=traefik
```

## 🧹 Cleanup

```bash
# Stop and remove VMs
vagrant destroy -f

# Remove Vagrant boxes (optional)
vagrant box remove bento/ubuntu-24.04
```

## 📚 Key Concepts Demonstrated

- ✅ **Deployments**: Managing application replicas
- ✅ **Services**: Internal load balancing (ClusterIP)
- ✅ **Ingress**: External HTTP routing with hostname rules
- ✅ **ConfigMaps**: Application configuration (if used)
- ✅ **Load Balancing**: Multiple pod replicas (App 2)
- ✅ **Default Backend**: Fallback routing for unmatched requests
- ✅ **Infrastructure as Code**: Vagrant + Kubernetes manifests

## 🔗 Related Resources

- [K3s Documentation](https://docs.k3s.io/)
- [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)

## 📝 Notes

- K3s comes with Traefik as the default Ingress Controller
- All manifests are automatically applied via the provisioning script
- The `/vagrant` directory is shared between host and VM
- App 2 demonstrates horizontal scaling with 3 replicas
- App 3 serves as both a named host and default backend

---

**Previous**: [Part 1 - K3s Cluster Setup](../p1/README.md) | **Next**: Part 3 (Coming Soon)
