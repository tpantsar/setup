#!/bin/bash

REPO_PATH="${REPO_PATH:-$HOME/setup}"
INSTALL_PATH="/usr/local/bin"

normalize_version() {
  printf '%s\n' "${1#v}"
}

# Get latest zk version from GitHub
ZK_VERSION=$(curl -fsSL "https://api.github.com/repos/zk-org/zk/releases/latest" | grep -Po '"tag_name": *"\K[^"]*')

if command -v zk >/dev/null 2>&1; then
  INSTALLED_ZK_VERSION=$(zk --version | awk '{print $2}')
else
  INSTALLED_ZK_VERSION=""
fi

ZK_VERSION_NORM=$(normalize_version "$ZK_VERSION")
INSTALLED_ZK_VERSION_NORM=$(normalize_version "$INSTALLED_ZK_VERSION")

# Install or update zk if needed
if [ -z "$INSTALLED_ZK_VERSION" ]; then
  echo "Installing zk $ZK_VERSION..."
elif [ "$INSTALLED_ZK_VERSION_NORM" != "$ZK_VERSION_NORM" ]; then
  echo "Updating zk from $INSTALLED_ZK_VERSION to $ZK_VERSION..."
else
  echo "zk is already up to date ($INSTALLED_ZK_VERSION)"
  exit 0
fi

# install to a temp directory first, then move to $INSTALL_PATH with sudo permissions
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

# https://github.com/zk-org/zk/releases/download/v0.15.2/zk-v0.15.2-linux-amd64.tar.gz
ARCHIVE="zk-${ZK_VERSION}-linux-amd64.tar.gz"
URL="https://github.com/zk-org/zk/releases/download/${ZK_VERSION}/${ARCHIVE}"

curl -fLo zk.tar.gz "$URL"
tar xf zk.tar.gz

ZK_BIN="$(find "$TMP_DIR" -type f -name zk | head -n 1)"
if [ -z "$ZK_BIN" ]; then
  echo "Could not find zk binary in archive" >&2
  exit 1
fi

echo "Installing to $INSTALL_PATH"
sudo install "$ZK_BIN" -D -t "$INSTALL_PATH"

echo "zk path: $(command -v zk)"
echo "zk version: $(zk --version)"
