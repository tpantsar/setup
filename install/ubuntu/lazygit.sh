#!/bin/bash

# Ensure git is installed
if ! command -v git &>/dev/null; then
  echo "git not found. Installing..."
  sudo apt update
  sudo apt install -y git
fi

# Get latest lazygit version from GitHub
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

# Get installed lazygit version, if present
INSTALLED_LAZYGIT_VERSION=""
if command -v lazygit &>/dev/null; then
  INSTALLED_LAZYGIT_VERSION=$(lazygit --version | grep -Po '(?<=, version=)[^,]+')
fi

# Install or update lazygit if needed
if [ -z "$INSTALLED_LAZYGIT_VERSION" ]; then
  echo "Installing lazygit $LAZYGIT_VERSION..."
elif [ "$INSTALLED_LAZYGIT_VERSION" != "$LAZYGIT_VERSION" ]; then
  echo "Updating lazygit from $INSTALLED_LAZYGIT_VERSION to $LAZYGIT_VERSION..."
else
  echo "lazygit is already up to date ($INSTALLED_LAZYGIT_VERSION)"
  exit 0
fi

# install to a temp directory first, then move to /usr/local/bin with sudo permissions
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR" || exit 1

curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# Test lazygit executable
which lazygit
lazygit --version
