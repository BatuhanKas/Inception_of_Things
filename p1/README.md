# Part 1: K3s Cluster with Vagrant

This project automatically sets up a 2-node K3s Kubernetes cluster using Vagrant.

## 📋 Table of Contents

- [Installation](#-installation)
- [Usage](#-usage)
- [Cluster Information](#-cluster-information)
- [Troubleshooting](#-troubleshooting)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│           K3s Cluster Topology              │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────────────┐  ┌─────────────────┐  │
│  │   bkasS (Server) │  │ bkasSW (Worker) │  │
│  │                  │  │                 │  │
│  │  IP: .110        │  │  IP: .111       │  │
│  │  Role: Master    │  │  Role: Worker   │  │
│  │  CPU: 1          │  │  CPU: 1         │  │
│  │  RAM: 1024MB     │  │  RAM: 1024MB    │  │
│  └──────────────────┘  └─────────────────┘  │
│           │                     │           │
│           └─────────┬───────────┘           │
│                     │                       │
│       Private Network (192.168.56.0/24)     │
└─────────────────────────────────────────────┘
```

## 🛠️ Requirements

### Software Requirements

- [Vagrant](https://www.vagrantup.com/downloads) >= 2.0
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) >= 6.0 (or VMware Fusion)
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
cd iot/p1
```

### 2. Start the VMs

```bash
# Start the entire cluster
vagrant up

# Start only the server node
vagrant up bkasS

# Start only the worker node
vagrant up bkasSW
```

The first startup may take 5-10 minutes (box download + installation).

### 3. Verify Installation

```bash
# Connect to server node and check cluster status
vagrant ssh bkasS -c "sudo kubectl get nodes -o wide"
```

**Expected Output:**

```
NAME     STATUS   ROLES                  AGE   VERSION        INTERNAL-IP       EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
bkass    Ready    control-plane,master   5m    v1.28.x+k3s1   192.168.56.110    <none>        Ubuntu 24.04 LTS     6.x.x-xx-generic   containerd://x.x.x
bkassw   Ready    <none>                 3m    v1.28.x+k3s1   192.168.56.111    <none>        Ubuntu 24.04 LTS     6.x.x-xx-generic   containerd://x.x.x
```

## 💻 Usage

### Basic Commands

```bash
# View VM status
vagrant status

# SSH into VMs
vagrant ssh bkasS          # Server node
vagrant ssh bkasSW         # Worker node

# Stop VMs
vagrant halt

# Restart VMs
vagrant reload

# Completely delete VMs
vagrant destroy -f

# Re-run provision scripts
vagrant provision
```

### Kubectl Commands (Inside Server Node)

```bash
# Connect to server node
vagrant ssh bkasS

# List nodes
sudo kubectl get nodes

# List pods
sudo kubectl get pods -A

# List namespaces
sudo kubectl get namespaces

# List services
sudo kubectl get services -A

# Create deployment
sudo kubectl create deployment nginx --image=nginx

# Scale deployment
sudo kubectl scale deployment nginx --replicas=3
```

## 📊 Cluster Information

| Feature | Value |
|---------|-------|
| **K3s Version** | Latest (automatic) |
| **Kubernetes API** | https://192.168.56.110:6443 |
| **Node Count** | 2 (1 Server + 1 Worker) |
| **Network Plugin** | Flannel (default) |
| **Ingress Controller** | Traefik (default) |
| **Storage Class** | local-path (default) |

### Node Details

#### bkasS (Server Node)
- **Hostname**: bkasS
- **IP**: 192.168.56.110
- **Role**: Control Plane, Master
- **Resources**: 1 CPU, 1024MB RAM
- **Script**: `scripts/install_k3s_server.sh`

#### bkasSW (Worker Node)
- **Hostname**: bkasSW
- **IP**: 192.168.56.111
- **Role**: Worker
- **Resources**: 1 CPU, 1024MB RAM
- **Script**: `scripts/install_k3s_worker.sh`

## 🔧 Troubleshooting

### Worker Node Not Showing Up

```bash
# Check token on server node
vagrant ssh bkasS -c "sudo cat /var/lib/rancher/k3s/server/node-token"

# Check worker node logs
vagrant ssh bkasSW -c "sudo journalctl -u k3s-agent -f"

# Rebuild VMs
vagrant destroy -f && vagrant up
```

### Network Connection Issues

```bash
# Test if nodes can reach each other
vagrant ssh bkasS -c "ping -c 3 192.168.56.111"
vagrant ssh bkasSW -c "ping -c 3 192.168.56.110"

# Check port accessibility
vagrant ssh bkasSW -c "nc -zv 192.168.56.110 6443"
```

### K3s Service Not Running

```bash
# On server node
vagrant ssh bkasS -c "sudo systemctl status k3s"
vagrant ssh bkasS -c "sudo systemctl restart k3s"

# On worker node
vagrant ssh bkasSW -c "sudo systemctl status k3s-agent"
vagrant ssh bkasSW -c "sudo systemctl restart k3s-agent"
```

### VM Too Slow

```bash
# Increase resources in Vagrantfile
vm.cpus = 2
vm.memory = 2048
```

## 📁 File Structure

```
p1/
├── Vagrantfile                      # VM definitions
├── README.md                        # This file
├── scripts/
│   ├── install_k3s_server.sh       # Server installation script
│   └── install_k3s_worker.sh       # Worker installation script
├── token                            # K3s join token (auto-generated)
└── .vagrant/                        # Vagrant metadata (should be ignored)
```

## 🎯 Next Steps

- [ ] Helm installation
- [ ] ArgoCD deployment
- [ ] Monitoring stack (Prometheus + Grafana)
- [ ] Ingress configuration
- [ ] Persistent volume tests

## 📚 Useful Links

- [K3s Documentation](https://docs.k3s.io/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)

## 📝 Notes

- Provision scripts run **only on first installation**
- `vagrant halt` + `vagrant up` → Scripts won't run
- `vagrant destroy` + `vagrant up` → Scripts will run again
- `vagrant provision` → Manually run scripts

---

**Author**: [BatuhanKas](https://github.com/BatuhanKas)  
**Date**: December 2025  
**Project**: IoT Infrastructure - Part 1
