#!/bin/bash
# https://dandavison.github.io/delta/installation.html
# https://github.com/dandavison/delta/releases

# Get latest git-delta version from GitHub
DELTA_VERSION=$(curl -fsSL "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": *"\K[^"]*')

# Get installed delta version, if present
INSTALLED_DELTA_VERSION=""
if command -v delta >/dev/null 2>&1; then
  INSTALLED_DELTA_VERSION=$(delta --version | awk '{print $2}')
fi

# Install or update delta if needed
if [ -z "$INSTALLED_DELTA_VERSION" ]; then
  echo "Installing delta $DELTA_VERSION..."
elif [ "$INSTALLED_DELTA_VERSION" != "$DELTA_VERSION" ]; then
  echo "Updating delta from $INSTALLED_DELTA_VERSION to $DELTA_VERSION..."
else
  echo "delta is already up to date ($INSTALLED_DELTA_VERSION)"
  exit 0
fi

# install to a temp directory first, then move to $INSTALL_PATH with sudo permissions
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

ARCHIVE="delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
URL="https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${ARCHIVE}"

curl -fLo delta.tar.gz "$URL"
tar xf delta.tar.gz

DELTA_BIN="$(find "$TMP_DIR" -type f -name delta | head -n 1)"
if [ -z "$DELTA_BIN" ]; then
  echo "Could not find delta binary in archive" >&2
  exit 1
fi

INSTALL_PATH="/usr/local/bin"
echo "Installing to $INSTALL_PATH"
sudo install "$DELTA_BIN" -D -t "$INSTALL_PATH"

echo "Delta path: $(command -v delta)"
echo "Delta version: $(delta --version)"
