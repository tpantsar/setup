#!/bin/bash

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

# Exit on any error
set -e

source "$SETUP_INSTALL/ubuntu/utils.sh"
echo "Starting system setup..."

# Update the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install packages
mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/ubuntu/packages.conf" | grep -v '^$')
install_packages "${packages[@]}"

# Install gnome specific things to make it like a tiling WM
source "$SETUP_INSTALL/ubuntu/gnome/gnome-extensions.sh"
source "$SETUP_INSTALL/ubuntu/gnome/gnome-hotkeys.sh"
source "$SETUP_INSTALL/ubuntu/gnome/gnome-settings.sh"

# Custom scripts
source "$SETUP_INSTALL/ubuntu/install-custom.sh"
source "$SETUP_INSTALL/ubuntu/install-flatpaks.sh"
source "$SETUP_INSTALL/ubuntu/install-fonts.sh"
source "$SETUP_INSTALL/ubuntu/install-homebrew.sh"

# Other
source "$SETUP_INSTALL/ubuntu/services.sh"
source "$SETUP_INSTALL/ubuntu/brightnessctl.sh"

echo "Setup complete! You may want to reboot your system."
