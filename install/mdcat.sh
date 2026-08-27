#!/bin/bash

set -euo pipefail

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1"
    exit 1
  }
}

need_cmd curl
need_cmd tar
need_cmd sudo

# Get latest mdcat version from GitHub
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/BIRSAx2/mdcat/releases/latest" | grep -Po '"tag_name": *"mdcat-\K[^"]*')

# Get installed mdcat version, if present
INSTALLED_VERSION=""
if command -v mdcat &>/dev/null; then
  INSTALLED_VERSION=$(mdcat --version | head -1 | awk '{print $2}')
fi

# Install or update mdcat if needed
if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing mdcat $LATEST_VERSION..."
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating mdcat from $INSTALLED_VERSION to $LATEST_VERSION..."
else
  echo "mdcat is already up to date ($INSTALLED_VERSION)"
  exit 0
fi

# install to a temp directory first, then move to /usr/local/bin with sudo permissions
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

# https://github.com/BIRSAx2/mdcat/releases/download/mdcat-2.15.0/mdcat-2.15.0-x86_64-unknown-linux-gnu.tar.gz
curl -Lo mdcat.tar.gz "https://github.com/BIRSAx2/mdcat/releases/download/mdcat-${LATEST_VERSION}/mdcat-${LATEST_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
mkdir -p mdcat
tar xf mdcat.tar.gz -C mdcat
sudo install -D "mdcat/mdcat-${LATEST_VERSION}-x86_64-unknown-linux-gnu/mdcat" /usr/local/bin/mdcat

echo "mdcat installed."
echo "mdcat path: $(command -v mdcat)"
echo "mdcat version: $(mdcat --version)"
