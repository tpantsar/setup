#!/usr/bin/env bash
# set -euo pipefail

# Install/update yazi binary from GitHub releases:
# https://github.com/sxyazi/yazi/releases
# https://yazi-rs.github.io/docs/installation/#binaries

ARCH=$(uname -m)

case "$ARCH" in
  x86_64)
    YAZI_ARCH="x86_64"
    ;;
  aarch64 | arm64)
    YAZI_ARCH="aarch64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

LATEST_VERSION="$(curl -fsSL "https://api.github.com/repos/sxyazi/yazi/releases/latest" | /usr/bin/grep -Po '"tag_name":\s*"v\K[^"]+')"

if [ -z "$LATEST_VERSION" ]; then
  echo "Failed to detect latest yazi version."
  exit 1
fi

INSTALLED_VERSION=""
if command -v yazi >/dev/null 2>&1; then
  INSTALLED_VERSION="$(yazi --version | awk '/Version:/ { print $2 }')"
  # INSTALLED_VERSION="$(yazi --version | awk '{print $2}' | sed 's/^v//')"
fi

if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing yazi $LATEST_VERSION..."
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating yazi from $INSTALLED_VERSION to $LATEST_VERSION..."
else
  echo "yazi is already up to date ($INSTALLED_VERSION)"
  exit 0
fi

sudo apt update
sudo apt install -y curl git ca-certificates

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# https://github.com/sxyazi/yazi/releases/download/v26.5.6/yazi-x86_64-unknown-linux-gnu.deb
URL="https://github.com/sxyazi/yazi/releases/download/v${LATEST_VERSION}/yazi-${YAZI_ARCH}-unknown-linux-gnu.deb"
curl -fL "$URL" -o "$TMP_DIR/yazi.deb"
sudo apt install -y "$TMP_DIR/yazi.deb"

echo "yazi path: $(command -v yazi)"
echo "yazi version: $(yazi --version)"
