#!/bin/bash

# Ensure git is installed
if ! command -v git &>/dev/null; then
  echo "git not found. Installing..."
  sudo apt update
  sudo apt install -y git
fi

# Lazydocker - https://github.com/jesseduffield/lazydocker?tab=readme-ov-file#ubuntu
if ! command -v lazydocker &>/dev/null; then
  echo "Installing lazydocker..."
  LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  # install to a temp directory first, then move to /usr/local/bin with sudo permissions
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT
  cd "$TMP_DIR"
  curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazydocker.tar.gz lazydocker
  sudo install lazydocker -D -t /usr/local/bin/

  # Test lazydocker executable
  which lazydocker
  lazydocker --version
else
  echo "lazydocker is already installed"
fi
