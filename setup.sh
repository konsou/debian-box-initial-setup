#!/usr/bin/env bash

source ./text-in-box.sh

box "Debian box setup script"
box "Upgrade existing packages"
sudo apt update
sudo apt upgrade -y

box "Install nala for nicer package installs"
sudo apt install nala -y
sudo nala fetch --auto

box "Install basic packages"
sudo nala install \
  nano \
  wget curl \
  ca-certificates \
  git \
  python-is-python3 python3-venv python3-pip \
  -y

box "Docker"
echo "Remove conflicting pkgs"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo "Add Docker GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Docker repo"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo nala update

echo "Install Docker"
sudo nala install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Test Docker"
sudo docker run --rm hello-world

echo "Docker post-install - allow current user without sudo"
# -f = don't error if exists
sudo groupadd -f docker
sudo usermod -aG docker $USER

box "Webmin"
curl -o webmin-setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repos.sh
sh webmin-setup-repos.sh
sudo nala install webmin -y


box "Complete!"

