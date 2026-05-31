#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"

source "$SETUP_INSTALL/utils.sh"
source "$SETUP_INSTALL/ubuntu/utils.sh"

echo "Creating necessary directories..."
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share/applications"

# Disable Snapd entirely (removes 12+ background services)
sudo systemctl disable --now snapd.socket snapd.seeded.service snapd.service
sudo apt purge -y snapd gnome-software-plugin-snap

# Disable unnecessary GNOME services
gsettings set org.gnome.desktop.session idle-delay 0 # Prevents auto-lock distraction
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0

# Enable ZRAM swap (reduces SSD wear, improves memory pressure response)
sudo apt install -y zram-config
sudo systemctl restart zram-config

echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y --allow-downgrades

echo "Checking config permissions..."
ls -ld ~ ~/.config ~/.local ~/.local/share ~/.local/share/applications

echo "Installing base packages..."
mapfile -t packages < <(packages_from_file "$SETUP_INSTALL/ubuntu/packages-base.apt")
install_packages "${packages[@]}"

# apps
run_exec "$SETUP_INSTALL/ubuntu/homebrew.sh"
run_exec "$SETUP_INSTALL/ubuntu/docker.sh"
run_exec "$SETUP_INSTALL/ubuntu/fzf.sh"
run_exec "$SETUP_INSTALL/ubuntu/eza.sh"
run_exec "$SETUP_INSTALL/ubuntu/starship.sh"
run_exec "$SETUP_INSTALL/ubuntu/zoxide.sh"
run_exec "$SETUP_INSTALL/ubuntu/delta.sh"
