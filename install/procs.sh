#!/bin/bash
# https://github.com/dalance/procs

set -euo pipefail

# Ensure git is installed
if ! command -v git &>/dev/null; then
  echo "git not found. Installing..."
  sudo apt update
  sudo apt install -y git
fi

# Get latest procs version from GitHub
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/dalance/procs/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

# Get installed procs version, if present
INSTALLED_VERSION=""
if command -v procs &>/dev/null; then
  INSTALLED_VERSION=$(procs --version | grep -Po 'procs "\K[^ ]+')
  # INSTALLED_VERSION=$(procs --version | grep -Po '"\K[0-9]+\.[0-9]+\.[0-9]+')
fi

# Install or update procs if needed
if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing procs $LATEST_VERSION..."
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating procs from $INSTALLED_VERSION to $LATEST_VERSION..."
else
  echo "procs is already up to date ($INSTALLED_VERSION)"
  exit 0
fi

# install to a temp directory first, then move to /usr/local/bin with sudo permissions
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR" || exit 1

# https://github.com/dalance/procs/releases/download/v0.14.12/procs-v0.14.12-x86_64-linux.zip
URL="https://github.com/dalance/procs/releases/download/v${LATEST_VERSION}/procs-v${LATEST_VERSION}-x86_64-linux.zip"
wget -O "procs.zip" "$URL"
unzip -o "procs.zip" -d .
sudo install procs -D -t /usr/local/bin/
rm -f procs.zip
rm -f procs

echo "procs path: $(command -v procs)"
echo "procs version: $(procs --version)"
