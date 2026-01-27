#!/bin/bash
set -e

SUDO_APT="sudo apt-get"
SUDO_APT_UPDATE="$SUDO_APT update"
SUDO_APT_INSTALL="$SUDO_APT install -y"

function is_installed()
{
    local arg=$1
    which "$arg" >/dev/null 2>&1
}

function install_curl()
{
    if ! is_installed curl; then
        echo "[INFO] Installing curl..."
        $SUDO_APT_UPDATE
        $SUDO_APT_INSTALL curl ca-certificates
    fi
}

function install_docker()
{
    if ! is_installed docker; then
        echo "[INFO] Installing Docker..."

        $SUDO_APT_UPDATE
        $SUDO_APT_INSTALL docker.io
        sudo systemctl enable docker
        sudo systemctl start docker

        echo "[INFO] Docker installed."
    fi
}

function install_kubectl()
{
    if ! is_installed kubectl; then
        echo "[INFO] Installing kubectl..."

        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod 777 kubectl
        sudo mv kubectl /usr/local/bin/

        echo "[INFO] kubectl installed."
    fi
}

function install_k3d()
{
    if ! is_installed k3d; then
        echo "[INFO] Installing k3d..."
        curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
        echo "[INFO] k3d installed."
    fi
}

echo "[SETUP] Install dependencies"

install_curl
install_docker
install_kubectl
install_k3d

echo "[SETUP] Setup completed successfully."