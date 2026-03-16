#!/bin/bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export SETUP_PATH="${SETUP_PATH:-$(cd "$SETUP_INSTALL/.." && pwd)}"

source "$SETUP_INSTALL/utils.sh"
source "$SETUP_INSTALL/ubuntu/utils.sh"

echo "Creating necessary directories..."
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share/applications"

echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y --allow-downgrades

echo "Checking config permissions..."
ls -ld ~ ~/.config ~/.local ~/.local/share ~/.local/share/applications

echo "Installing base packages..."
mapfile -t packages < <(packages_from_file "$SETUP_INSTALL/ubuntu/packages-base.apt")
install_packages "${packages[@]}"

echo "Configuring passwordless sudo..."
bash "$SETUP_INSTALL/bypass-sudo.sh"

echo "Fixing permissions..."
bash "$SETUP_INSTALL/setup-permissions.sh"

run_exec "$SETUP_INSTALL/ubuntu/fzf.sh"
run_exec "$SETUP_INSTALL/ubuntu/eza.sh"
run_exec "$SETUP_INSTALL/ubuntu/starship.sh"
