#!/bin/bash
# Install tree-sitter-cli from GitHub releases
# https://github.com/tree-sitter/tree-sitter/releases

set -e

ARCH=$(uname -m)

case "$ARCH" in
  x86_64)
    TS_ARCH="linux-x64"
    ;;
  aarch64 | arm64)
    TS_ARCH="linux-arm64"
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

# Get latest tree-sitter-cli version from GitHub
LATEST_VERSION=$(curl -s "https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest" | /usr/bin/grep -Po '"tag_name": *"v\K[^"]*')

# Get installed tree-sitter-cli version, if present
INSTALLED_VERSION=""
if command -v tree-sitter &>/dev/null; then
  INSTALLED_VERSION=$(tree-sitter --version | awk '{print $2}')
fi

# Install or update tree-sitter-cli if needed
if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing tree-sitter-cli $LATEST_VERSION..."
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating tree-sitter-cli from $INSTALLED_VERSION to $LATEST_VERSION..."
else
  echo "tree-sitter-cli is already up to date ($INSTALLED_VERSION)"
  exit 0
fi

# Install to a temp directory first
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

# Download correct architecture binary
# Tree‑sitter's GitHub release provides a single binary compressed with gzip, not a tarball.
# https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.10/tree-sitter-linux-x64.gz
URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${LATEST_VERSION}/tree-sitter-${TS_ARCH}.gz"
echo "Downloading: $URL"
curl -L -o tree-sitter.gz "$URL"

# Extract gzip (single file)
gunzip tree-sitter.gz

# Install binary
sudo install tree-sitter -D -t /usr/local/bin/

# Test tree-sitter executable
echo "tree-sitter path: $(command -v tree-sitter)"
echo "tree-sitter version: $(tree-sitter --version)"
