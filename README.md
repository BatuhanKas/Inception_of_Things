# Inception of Things (IoT)

A comprehensive infrastructure-as-code project focused on Kubernetes cluster deployment, automation, and GitOps practices using modern DevOps tools.

## 📋 Overview

This project demonstrates the setup and configuration of Kubernetes environments using various orchestration and automation tools. Each part focuses on different aspects of container orchestration, from basic cluster setup to advanced GitOps workflows.

## 🎯 Project Goals

- **Infrastructure as Code**: Automate cluster provisioning with Vagrant
- **Container Orchestration**: Deploy and manage K3s Kubernetes clusters
- **GitOps Practices**: Implement continuous deployment with ArgoCD
- **High Availability**: Configure multi-node clusters with proper networking
- **Best Practices**: Follow industry standards for security and scalability

## 🗂️ Project Structure

```
iot/
├── p1/          # Part 1: K3s Cluster Setup
├── p2/          # Part 2: Advanced Configuration (Coming Soon)
├── p3/          # Part 3: GitOps with ArgoCD (Coming Soon)
└── README.md    # This file
```

## 📦 Parts Overview

### Part 1: K3s Cluster with Vagrant ✅

**Status**: Completed

Set up a 2-node K3s Kubernetes cluster using Vagrant and VirtualBox/VMware.

**Features**:
- Automated VM provisioning
- K3s server (master) and worker nodes
- Private network configuration
- Shell script automation

**Tech Stack**: Vagrant, VirtualBox, K3s, Bash

📖 [Detailed Documentation →](./p1/README.md)

---

### Part 2: K3s with Applications and Ingress ✅

**Status**: Completed

Deploy multiple applications with services and implement hostname-based routing using Kubernetes Ingress.

**Features**:
- Three containerized applications (app1, app2, app3)
- ClusterIP services for internal load balancing
- Traefik Ingress Controller with hostname routing
- High availability setup (App 2 with 3 replicas)
- Default backend routing for fallback requests
- Automated deployment via Vagrant provisioning

**Tech Stack**: K3s, Traefik, Kubernetes Services, Ingress, http-echo

📖 [Detailed Documentation →](./p2/README.md)

---

### Part 3: K3D and GitOps with ArgoCD 🔜

**Status**: Planned

Deploy a K3s cluster in Docker and implement GitOps workflows with ArgoCD.

**Planned Features**:
- K3D cluster setup
- ArgoCD installation and configuration
- Automated application deployment
- Git-based continuous delivery

**Tech Stack**: K3D, ArgoCD, Helm, Git

📖 Documentation: Coming Soon

---

## 🛠️ Prerequisites

### Required Software

- **Vagrant** >= 2.0 - VM automation
- **VirtualBox** >= 6.0 or **VMware Fusion** - Virtualization
- **Git** - Version control
- **kubectl** - Kubernetes CLI (optional for host machine)

### System Requirements

- **OS**: macOS, Linux, or Windows (WSL2)
- **RAM**: Minimum 4GB free (8GB+ recommended)
- **Disk**: Minimum 20GB free space
- **CPU**: Multi-core processor (2+ cores recommended)

### Installation

```bash
# macOS
brew install vagrant
brew install --cask virtualbox

# Ubuntu/Debian
sudo apt-get install vagrant virtualbox

# Windows (WSL2)
choco install vagrant
choco install virtualbox
```

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/BatuhanKas/iot.git
cd iot

# Navigate to desired part
cd p1

# Start the cluster
vagrant up

# Verify installation
vagrant ssh bkasS -c "sudo kubectl get nodes"
```

## 📚 Learning Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [K3s Documentation](https://docs.k3s.io/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [GitOps Principles](https://www.gitops.tech/)

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Batuhan Kas**
- GitHub: [@BatuhanKas](https://github.com/BatuhanKas)
- GitHub: [@erendemirer1](https://github.com/erendemirer1)
- Project: [Inception of Things](https://github.com/BatuhanKas/iot)

## 🙏 Acknowledgments

- [42 School](https://www.42.fr/) for project inspiration
- K3s community for lightweight Kubernetes
- HashiCorp for Vagrant
- Argo Project for GitOps tooling

## 📊 Project Status

| Part | Status | Progress |
|------|--------|----------|
| Part 1 | ✅ Complete | 100% |
| Part 2 | 🚧 In Progress | 0% |
| Part 3 | 🔜 Planned | 0% |

---

**Last Updated**: December 2025  
**Version**: 1.0.0
