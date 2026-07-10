#!/bin/bash

# impala: TUI for managing wifi on Linux.
# https://github.com/pythops/impala
# IMPORTANT: To avoid conflicts, ensure wireless management services like NetworkManager or wpa_supplicant are disabled.
# iwd needs to be running: https://archive.kernel.org/oldwiki/iwd.wiki.kernel.org/gettingstarted.html

# Ensure git is installed
if ! command -v git &>/dev/null; then
  echo "git not found. Installing..."
  sudo apt update
  sudo apt install -y git
fi

# Get latest impala version from GitHub
LATEST_VERSION=$(curl -s "https://api.github.com/repos/pythops/impala/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

# Get installed impala version, if present
INSTALLED_VERSION=""
if command -v impala &>/dev/null; then
  INSTALLED_VERSION=$(impala --version | awk '{print $2}')
fi

# Install or update impala if needed
if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing impala $LATEST_VERSION..."
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating impala from $INSTALLED_VERSION to $LATEST_VERSION..."
else
  echo "impala is already up to date ($INSTALLED_VERSION)"
  exit 0
fi

# Install to a temp directory first
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

# Download correct architecture binary
# https://github.com/pythops/impala/releases/download/v0.7.4/impala-x86_64-unknown-linux-musl
URL="https://github.com/pythops/impala/releases/download/v${LATEST_VERSION}/impala-x86_64-unknown-linux-musl"
echo "Downloading: $URL"
curl -L -o impala "$URL"

# Install binary
sudo install impala -D -t /usr/local/bin/

echo "installing iwd from apt, a background service required for impala..."
sudo apt install -y iwd

echo "impala path: $(command -v impala)"
echo "impala version: $(impala --version)"
