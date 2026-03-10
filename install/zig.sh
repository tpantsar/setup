#!/usr/bin/env bash
# Install Zig programming language (versioned layout)
# Layout:
#   /usr/local/zig/zig-<version>/   ← extracted bundle
#   /usr/local/zig/current          → symlink to active version
#   /usr/local/bin/zig              → symlink to /usr/local/zig/current/zig

set -euo pipefail

if command -v zig >/dev/null 2>&1; then
  echo "zig is already installed: $(zig version)"
  exit 0
fi

VER="${VER:-0.14.1}"

# Detect platform/arch (extend if you need more)
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64 | amd64) ARCH="x86_64" ;;
  aarch64 | arm64) ARCH="aarch64" ;;
  *)
    echo "Unsupported arch: $ARCH" >&2
    exit 1
    ;;
esac

# Zig download naming uses "linux" / "macos" etc
case "$OS" in
  linux) PLATFORM="linux" ;;
  darwin) PLATFORM="macos" ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 1
    ;;
esac

TARBALL="zig-${ARCH}-${PLATFORM}-${VER}.tar.xz"
URL="https://ziglang.org/download/${VER}/${TARBALL}"

DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
mkdir -p "$DOWNLOAD_DIR"
ARCHIVE="${DOWNLOAD_DIR}/${TARBALL}"

echo "Downloading: $URL"
curl -fL --retry 3 --retry-delay 1 -o "$ARCHIVE" "$URL"

echo "Installing to /usr/local/zig/zig-$VER"
sudo mkdir -p /usr/local/zig
sudo rm -rf "/usr/local/zig/zig-$VER"
sudo mkdir -p "/usr/local/zig/zig-$VER"
sudo tar -xJf "$ARCHIVE" -C "/usr/local/zig/zig-$VER" --strip-components=1

echo "Updating symlinks"
sudo ln -sfn "/usr/local/zig/zig-$VER" /usr/local/zig/current
sudo ln -sfn /usr/local/zig/current/zig /usr/local/bin/zig

echo "Done. Zig version:"
zig version
