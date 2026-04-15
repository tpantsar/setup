#!/bin/bash

# Ensure git is installed
if ! command -v git &>/dev/null; then
  echo "git not found. Installing..."
  sudo apt update
  sudo apt install -y git
fi

# Get latest lazydocker version from GitHub
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

# Get installed lazydocker version, if present
INSTALLED_LAZYDOCKER_VERSION=""
if command -v lazydocker &>/dev/null; then
  INSTALLED_LAZYDOCKER_VERSION=$(lazydocker --version | grep -Po '(?<=Version:)\s*\K[^, ]+')
fi

# Install or update lazydocker if needed
if [ -z "$INSTALLED_LAZYDOCKER_VERSION" ]; then
  echo "Installing lazydocker $LAZYDOCKER_VERSION..."
elif [ "$INSTALLED_LAZYDOCKER_VERSION" != "$LAZYDOCKER_VERSION" ]; then
  echo "Updating lazydocker from $INSTALLED_LAZYDOCKER_VERSION to $LAZYDOCKER_VERSION..."
else
  echo "lazydocker is already up to date ($INSTALLED_LAZYDOCKER_VERSION)"
  exit 0
fi

# install to a temp directory first, then move to /usr/local/bin with sudo permissions
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR" || exit 1

curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar xf lazydocker.tar.gz lazydocker
sudo install lazydocker -D -t /usr/local/bin/

# Test lazydocker executable
which lazydocker
lazydocker --version
