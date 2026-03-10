#!/bin/bash

set -eEo pipefail

# Install paths
export SETUP_PATH="$HOME/setup"
export SETUP_INSTALL="$SETUP_PATH/install"

# Print the logo
print_logo() {
  cat <<"EOF"
    ______                _ __    __     
   / ____/______  _______(_) /_  / /__   
  / /   / ___/ / / / ___/ / __ \/ / _ \  
 / /___/ /  / /_/ / /__/ / /_/ / /  __/  Ubuntu/Debian System Crafting Tool
 \____/_/   \__,_/\___/_/_.___/_/\___/

EOF
}

# Clear screen and show logo
clear
print_logo

source "$SETUP_INSTALL/ubuntu/utils.sh"

# Update the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install packages
mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/ubuntu/packages.apt" | grep -v '^$')
install_packages "${packages[@]}"

# Ensure that local/bin directory exists for custom executables
mkdir -p ~/.local/bin/

# Custom scripts
bash "$SETUP_INSTALL/ubuntu/base.sh"
bash "$SETUP_INSTALL/ubuntu/custom.sh"
bash "$SETUP_INSTALL/ubuntu/firefox.sh"
bash "$SETUP_INSTALL/ubuntu/curl.sh"
bash "$SETUP_INSTALL/ubuntu/git.sh"
bash "$SETUP_INSTALL/ubuntu/docker.sh"
bash "$SETUP_INSTALL/ubuntu/alacritty.sh"
bash "$SETUP_INSTALL/ubuntu/kitty.sh"
bash "$SETUP_INSTALL/ubuntu/ghostty.sh"
bash "$SETUP_INSTALL/ubuntu/i3.sh"
bash "$SETUP_INSTALL/ubuntu/onedrive.sh"
bash "$SETUP_INSTALL/ubuntu/vscode.sh"
bash "$SETUP_INSTALL/ubuntu/yazi.sh"
bash "$SETUP_INSTALL/ubuntu/go.sh"
# bash "$SETUP_INSTALL/ubuntu/flatpaks.sh"
bash "$SETUP_INSTALL/ubuntu/fonts.sh"
bash "$SETUP_INSTALL/ubuntu/homebrew.sh"

# Other
bash "$SETUP_INSTALL/ubuntu/services.sh"
bash "$SETUP_INSTALL/ubuntu/brightnessctl.sh"

# Install gnome specific things to make it like a tiling WM
bash "$SETUP_INSTALL/ubuntu/gnome/gnome-extensions.sh"
bash "$SETUP_INSTALL/ubuntu/gnome/gnome-hotkeys.sh"
bash "$SETUP_INSTALL/ubuntu/gnome/gnome-settings.sh"
