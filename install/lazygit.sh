#!/bin/bash

# Ensure git is installed
if ! command -v git &>/dev/null; then
  echo "git not found. Installing..."
  sudo apt update
  sudo apt install -y git
fi

# Get latest lazygit version from GitHub
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

# Get installed lazygit version, if present
INSTALLED_VERSION=""
if command -v lazygit &>/dev/null; then
  INSTALLED_VERSION=$(lazygit --version | grep -Po '(?<=, version=)[^,]+')
fi

# Install or update lazygit if needed
if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing lazygit $LATEST_VERSION..."
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating lazygit from $INSTALLED_VERSION to $LATEST_VERSION..."
else
  echo "lazygit is already up to date ($INSTALLED_VERSION)"
  exit 0
fi

# install to a temp directory first, then move to /usr/local/bin with sudo permissions
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR" || exit 1

curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LATEST_VERSION}/lazygit_${LATEST_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

echo "lazygit path: $(command -v lazygit)"
echo "lazygit version: $(lazygit --version)"
