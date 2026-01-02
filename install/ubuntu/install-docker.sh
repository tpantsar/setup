#!/bin/bash

# Docker - https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
if ! command -v docker &>/dev/null; then
  echo "Installing docker ..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh

  # Test docker executable
  /usr/bin/docker version

  # Add sudo permissions to your user
  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  groups | grep -i docker
  /usr/bin/docker ps
else
  echo "docker is already installed"
fi

# Lazydocker - https://github.com/jesseduffield/lazydocker?tab=readme-ov-file#ubuntu
if ! command -v lazydocker &>/dev/null; then
  echo "Installing lazydocker..."
  LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazydocker.tar.gz lazydocker
  sudo install lazydocker -D -t /usr/local/bin/

  # Test lazydocker executable
  which lazydocker
  lazydocker --version
else
  echo "lazydocker is already installed"
fi
