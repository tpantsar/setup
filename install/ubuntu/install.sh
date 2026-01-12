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
bash "$SETUP_INSTALL/ubuntu/install-custom.sh"
bash "$SETUP_INSTALL/ubuntu/install-git.sh"
bash "$SETUP_INSTALL/ubuntu/install-docker.sh"
bash "$SETUP_INSTALL/ubuntu/install-alacritty.sh"
bash "$SETUP_INSTALL/ubuntu/install-kitty.sh"
bash "$SETUP_INSTALL/ubuntu/install-i3.sh"
bash "$SETUP_INSTALL/ubuntu/install-onedrive.sh"
bash "$SETUP_INSTALL/ubuntu/install-go.sh"
# bash "$SETUP_INSTALL/ubuntu/install-flatpaks.sh"
bash "$SETUP_INSTALL/ubuntu/install-fonts.sh"
bash "$SETUP_INSTALL/ubuntu/install-homebrew.sh"

# Other
bash "$SETUP_INSTALL/ubuntu/services.sh"
bash "$SETUP_INSTALL/ubuntu/brightnessctl.sh"

# Install gnome specific things to make it like a tiling WM
bash "$SETUP_INSTALL/ubuntu/gnome/gnome-extensions.sh"
bash "$SETUP_INSTALL/ubuntu/gnome/gnome-hotkeys.sh"
bash "$SETUP_INSTALL/ubuntu/gnome/gnome-settings.sh"
