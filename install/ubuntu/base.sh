#!/bin/bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export SETUP_PATH="${SETUP_PATH:-$(cd "$SETUP_INSTALL/.." && pwd)}"

source "$SETUP_INSTALL/ubuntu/utils.sh"

echo "Creating necessary directories..."
mkdir -p "$HOME/.local/bin"

echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y

echo "Checking config permissions..."
ls -ld ~ ~/.config ~/.local ~/.local/share ~/.local/share/applications

echo "Installing base packages..."
mapfile -t packages < <(packages_from_file "$SETUP_INSTALL/ubuntu/packages-base.apt")
install_packages "${packages[@]}"
