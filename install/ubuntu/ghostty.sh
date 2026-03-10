#!/usr/bin/env bash
# Install ghostty
# https://ghostty.org/docs/install/build

set -euo pipefail

if command -v ghostty >/dev/null 2>&1; then
  echo "ghostty is already installed: $(ghostty --version)"
  exit 0
fi

# Dependencies
sudo apt-get update
sudo apt install -y libgtk-4-dev libadwaita-1-dev gettext libxml2-utils minisign pkg-config build-essential

VERSION="1.2.3"
PREFIX="${PREFIX:-$HOME/.local}"
PUBKEY='RWQlAjJC23149WL2sEpT/l0QKy7hMIFhYdQOFy0Z7z7PbneUgvlsnYcV'

tarball="ghostty-${VERSION}.tar.gz"
base="https://release.files.ghostty.org/${VERSION}"

# Download tarball and its signature
cd "$HOME/Downloads"
curl -fL -o "$tarball" "${base}/${tarball}"
curl -fL -o "${tarball}.minisig" "${base}/${tarball}.minisig"

if [[ "${SKIP_VERIFY:-0}" != "1" ]]; then
  command -v minisign >/dev/null || {
    echo "minisign missing (install it or set SKIP_VERIFY=1)"
    exit 1
  }
  minisign -Vm "$tarball" -P "$PUBKEY" >/dev/null
fi

topdir="$(tar -tf "$tarball" | head -n1 | cut -d/ -f1)"
tar -xf "$tarball"
cd "$topdir"

# https://ghostty.org/docs/install/build#linux
extra=()
if command -v pkg-config >/dev/null && ! pkg-config --exists gtk4-layer-shell-0 2>/dev/null; then
  extra+=("-fno-sys=gtk4-layer-shell")
fi

sudo zig build -p "$PREFIX" -Doptimize=ReleaseFast "${extra[@]}"

echo "ghostty installed to: $PREFIX/bin/ghostty"
