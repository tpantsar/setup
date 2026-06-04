#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"

source "$SETUP_INSTALL/utils.sh"
source "$SETUP_INSTALL/ubuntu/utils.sh"

echo "Updating system packages with apt..."
sudo apt update
sudo apt upgrade -y --allow-downgrades

echo "Creating necessary config directories..."
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

echo "Checking config permissions..."
ls -ld ~ ~/.config ~/.local ~/.local/share ~/.local/share/applications

echo "Installing base packages..."
mapfile -t packages < <(packages_from_file "$SETUP_INSTALL/ubuntu/packages-base.apt")
install_packages "${packages[@]}"

echo "Enabling firewall..."
sudo "$SETUP_INSTALL/ubuntu/firewall.sh"

# apps
run_exec "$SETUP_INSTALL/ubuntu/zsh.sh"
run_exec "$SETUP_INSTALL/ubuntu/docker.sh"
run_exec "$SETUP_INSTALL/ubuntu/fzf.sh"
run_exec "$SETUP_INSTALL/ubuntu/eza.sh"
run_exec "$SETUP_INSTALL/ubuntu/starship.sh"
run_exec "$SETUP_INSTALL/ubuntu/zoxide.sh"
run_exec "$SETUP_INSTALL/ubuntu/delta.sh"

echo "Ubuntu base installation done!"

if [[ "$MODE" == "base" ]]; then
  echo "MODE=$MODE. Skipping desktop installation on Ubuntu."
  exit 0
fi

# desktop
mapfile -t packages < <(packages_from_file "$SETUP_INSTALL/ubuntu/packages-full.apt")
install_packages "${packages[@]}"

# Ensure ~/.local/bin exists for user-installed binaries
mkdir -p "$HOME/.local/bin"

echo "Setting default web browser alternatives..."
sudo update-alternatives --config x-www-browser
sudo update-alternatives --config www-browser
sudo update-alternatives --config gnome-www-browser

run_exec "$SETUP_INSTALL/ubuntu/homebrew.sh"
run_exec "$SETUP_INSTALL/ubuntu/fonts.sh"
run_exec "$SETUP_INSTALL/ubuntu/neovim.sh"
run_exec "$SETUP_INSTALL/ubuntu/firefox.sh"
run_exec "$SETUP_INSTALL/ubuntu/uv.sh"
run_exec "$SETUP_INSTALL/ubuntu/kitty.sh"
run_exec "$SETUP_INSTALL/ubuntu/lazygit.sh"
run_exec "$SETUP_INSTALL/ubuntu/lazydocker.sh"
run_exec "$SETUP_INSTALL/ubuntu/bat.sh"
run_exec "$SETUP_INSTALL/ubuntu/go.sh"
run_exec "$SETUP_INSTALL/ubuntu/brightnessctl.sh"
run_exec "$SETUP_INSTALL/ubuntu/autorandr.sh"
run_exec "$SETUP_INSTALL/ubuntu/betterlockscreen.sh"
run_exec "$SETUP_INSTALL/ubuntu/tmux.sh"

# cargo
run_exec "$SETUP_INSTALL/ubuntu/alacritty-source.sh"
run_exec "$SETUP_INSTALL/ubuntu/fd.sh"
run_exec "$SETUP_INSTALL/ubuntu/yazi.sh"
run_exec "$SETUP_INSTALL/ubuntu/treesitter.sh"

# homebrew
run_exec "$SETUP_INSTALL/ubuntu/fastfetch.sh"
run_exec "$SETUP_INSTALL/ubuntu/gum.sh"
run_exec "$SETUP_INSTALL/ubuntu/glab.sh"
