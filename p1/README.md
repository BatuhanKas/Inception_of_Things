# Part 1: K3s Cluster with Vagrant

Bu proje, Vagrant kullanarak otomatik olarak 2 node'lu bir K3s Kubernetes cluster'ı kurar.

## 📋 İçindekiler

- [Mimari](#-mimari)
- [Gereksinimler](#-gereksinimler)
- [Kurulum](#-kurulum)
- [Kullanım](#-kullanım)
- [Cluster Bilgileri](#-cluster-bilgileri)
- [Sorun Giderme](#-sorun-giderme)

## 🏗️ Mimari

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
│           Private Network (192.168.56.0/24) │
└─────────────────────────────────────────────┘
```

## 🛠️ Gereksinimler

### Yazılım Gereksinimleri

- [Vagrant](https://www.vagrantup.com/downloads) >= 2.0
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) >= 6.0 (veya VMware Fusion)
- Minimum 2GB boş RAM
- Minimum 10GB boş disk alanı

### Sistem Gereksinimleri

- **macOS**: Intel veya Apple Silicon (ARM64)
- **Linux**: x86_64 veya ARM64
- **Windows**: WSL2 önerilir

## 🚀 Kurulum

### 1. Repository'i Klonlayın

```bash
git clone <repo-url>
cd iot/p1
```

### 2. VM'leri Başlatın

```bash
# Tüm cluster'ı başlat
vagrant up

# Sadece server node'u başlat
vagrant up bkasS

# Sadece worker node'u başlat
vagrant up bkasSW
```

İlk başlatma 5-10 dakika sürebilir (box indirme + kurulum).

### 3. Kurulumu Doğrulayın

```bash
# Server node'a bağlan ve cluster durumunu kontrol et
vagrant ssh bkasS -c "sudo kubectl get nodes -o wide"
```

**Beklenen Çıktı:**

```
NAME     STATUS   ROLES                  AGE   VERSION        INTERNAL-IP       EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
bkass    Ready    control-plane,master   5m    v1.28.x+k3s1   192.168.56.110    <none>        Ubuntu 24.04 LTS     6.x.x-xx-generic   containerd://x.x.x
bkassw   Ready    <none>                 3m    v1.28.x+k3s1   192.168.56.111    <none>        Ubuntu 24.04 LTS     6.x.x-xx-generic   containerd://x.x.x
```

## 💻 Kullanım

### Temel Komutlar

```bash
# VM durumunu görüntüle
vagrant status

# VM'lere SSH ile bağlan
vagrant ssh bkasS          # Server node
vagrant ssh bkasSW         # Worker node

# VM'leri durdur
vagrant halt

# VM'leri yeniden başlat
vagrant reload

# VM'leri tamamen sil
vagrant destroy -f

# Provision scriptlerini yeniden çalıştır
vagrant provision
```

### Kubectl Komutları (Server Node İçinde)

```bash
# Server node'a bağlan
vagrant ssh bkasS

# Node'ları listele
sudo kubectl get nodes

# Pod'ları listele
sudo kubectl get pods -A

# Namespace'leri listele
sudo kubectl get namespaces

# Servis'leri listele
sudo kubectl get services -A

# Deployment oluştur
sudo kubectl create deployment nginx --image=nginx

# Deployment'ı scale et
sudo kubectl scale deployment nginx --replicas=3
```

### Host'tan Kubectl Kullanımı (Opsiyonel)

```bash
# Kubeconfig dosyasını kopyala
vagrant ssh bkasS -c "sudo cat /etc/rancher/k3s/k3s.yaml" > ~/.kube/config-k3s

# Server IP'sini güncelle
sed -i '' 's/127.0.0.1/192.168.56.110/g' ~/.kube/config-k3s

# Kullan
kubectl --kubeconfig=~/.kube/config-k3s get nodes
```

## 📊 Cluster Bilgileri

| Özellik | Değer |
|---------|-------|
| **K3s Versiyonu** | Latest (otomatik) |
| **Kubernetes API** | https://192.168.56.110:6443 |
| **Node Sayısı** | 2 (1 Server + 1 Worker) |
| **Network Plugin** | Flannel (default) |
| **Ingress Controller** | Traefik (default) |
| **Storage Class** | local-path (default) |

### Node Detayları

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

## 🔧 Sorun Giderme

### Worker Node Görünmüyor

```bash
# Server node'da token kontrolü
vagrant ssh bkasS -c "sudo cat /var/lib/rancher/k3s/server/node-token"

# Worker node loglarını kontrol et
vagrant ssh bkasSW -c "sudo journalctl -u k3s-agent -f"

# VM'leri yeniden kur
vagrant destroy -f && vagrant up
```

### Network Bağlantı Sorunları

```bash
# Node'ların birbirini görüp görmediğini test et
vagrant ssh bkasS -c "ping -c 3 192.168.56.111"
vagrant ssh bkasSW -c "ping -c 3 192.168.56.110"

# Port erişimini kontrol et
vagrant ssh bkasSW -c "nc -zv 192.168.56.110 6443"
```

### K3s Servisi Çalışmıyor

```bash
# Server node'da
vagrant ssh bkasS -c "sudo systemctl status k3s"
vagrant ssh bkasS -c "sudo systemctl restart k3s"

# Worker node'da
vagrant ssh bkasSW -c "sudo systemctl status k3s-agent"
vagrant ssh bkasSW -c "sudo systemctl restart k3s-agent"
```

### VM Çok Yavaş

```bash
# Vagrantfile'da resource'ları artır
vm.cpus = 2
vm.memory = 2048
```

### Apple Silicon (M1/M2/M3/M4) Hataları

VirtualBox ARM64 desteği sınırlıdır. Alternatifler:

```bash
# VMware Fusion kullan
brew install --cask vmware-fusion
vagrant plugin install vagrant-vmware-desktop

# Vagrantfile'da provider değiştir
config.vm.provider "vmware_desktop"

# UTM kullan (ücretsiz)
brew install --cask utm
vagrant plugin install vagrant-qemu
```

## 📁 Dosya Yapısı

```
p1/
├── Vagrantfile                      # VM tanımlamaları
├── README.md                        # Bu dosya
├── scripts/
│   ├── install_k3s_server.sh       # Server kurulum scripti
│   └── install_k3s_worker.sh       # Worker kurulum scripti
├── token                            # K3s join token (otomatik oluşur)
└── .vagrant/                        # Vagrant metadata (ignore edilmeli)
```

## 🎯 Sonraki Adımlar

- [ ] Helm kurulumu
- [ ] ArgoCD deployment
- [ ] Monitoring stack (Prometheus + Grafana)
- [ ] Ingress konfigürasyonu
- [ ] Persistent volume testleri

## 📚 Faydalı Linkler

- [K3s Documentation](https://docs.k3s.io/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)

## 📝 Notlar

- Provision scriptleri **sadece ilk kurulumda** çalışır
- `vagrant halt` + `vagrant up` → Scriptler çalışmaz
- `vagrant destroy` + `vagrant up` → Scriptler yeniden çalışır
- `vagrant provision` → Scriptleri manuel çalıştırır

---

**Hazırlayan**: [BatuhanKas](https://github.com/BatuhanKas)  
**Tarih**: Aralık 2025  
**Proje**: IoT Infrastructure - Part 1
