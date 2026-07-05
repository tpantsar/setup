#!/bin/bash
# Install fastfetch from GitHub releases
# https://github.com/fastfetch-cli/fastfetch/releases

set -e

ARCH=$(uname -m)

case "$ARCH" in
  x86_64)
    FF_ARCH="amd64"
    ;;
  aarch64 | arm64)
    FF_ARCH="aarch64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Ensure git is installed
if ! command -v git &>/dev/null; then
  echo "git not found. Installing from apt..."
  sudo apt update
  sudo apt install -y git
fi

# Get latest fastfetch version from GitHub
LATEST_VERSION=$(curl -s "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" | /usr/bin/grep -Po '"tag_name": *"\K[^"]*')

# Get installed fastfetch version, if present
INSTALLED_VERSION=""
if command -v fastfetch &>/dev/null; then
  INSTALLED_VERSION=$(fastfetch --version | awk '{print $2}')
fi

# Install or update fastfetch if needed
if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing fastfetch $LATEST_VERSION..."
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating fastfetch from $INSTALLED_VERSION to $LATEST_VERSION..."
else
  echo "fastfetch is already up to date ($INSTALLED_VERSION)"
  exit 0
fi

# Install to a temp directory first
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

# Download correct architecture binary
# https://github.com/fastfetch-cli/fastfetch/releases/download/2.65.2/fastfetch-linux-amd64.tar.gz
URL="https://github.com/fastfetch-cli/fastfetch/releases/download/${LATEST_VERSION}/fastfetch-linux-${FF_ARCH}.tar.gz"
echo "Downloading: $URL"
curl -L -o fastfetch.tar.gz "$URL"

# Extract tar archive
tar xf fastfetch.tar.gz

# Find the extracted directory
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "fastfetch-linux-*")

# Install binary from usr/bin inside the archive
sudo install "$EXTRACTED_DIR/usr/bin/fastfetch" -D -t /usr/local/bin/

echo "fastfetch path: $(command -v fastfetch)"
echo "fastfetch version: $(fastfetch --version)"
