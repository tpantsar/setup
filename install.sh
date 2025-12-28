#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

source /etc/os-release
clear

# Clone the setup repository
git clone https://github.com/tpantsar/setup.git ~/setup || true

# Install paths
export SETUP_PATH="$HOME/setup"
export SETUP_INSTALL="$SETUP_PATH/install"

# Base installation
source "$SETUP_INSTALL/bypass-sudo.sh"
source "$SETUP_INSTALL/add-ssh-key-gh.sh"
source "$SETUP_INSTALL/install-dotfiles.sh"
#source "$SETUP_INSTALL/install-luarocks.sh"
source "$SETUP_INSTALL/install-tmux.sh"
source "$SETUP_INSTALL/install-zsh.sh"
source "$SETUP_INSTALL/install-fzf.sh"
source "$SETUP_INSTALL/install-gcalcli.sh"
source "$SETUP_INSTALL/setup-repos.sh"
source "$SETUP_INSTALL/setup-tmux.sh"
source "$SETUP_INSTALL/setup-onedrive.sh"
source "$SETUP_INSTALL/set-shell.sh"
source "$SETUP_INSTALL/set-default-browser.sh"

# Distro-specific installation
if [[ "$ID" == "arch" ]]; then
  source "$SETUP_INSTALL/arch/install.sh"
elif [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
  source "$SETUP_INSTALL/ubuntu/install.sh"
else
  echo "Other distro: $ID"
  echo "Unsupported distribution. Exiting."
  exit 1
fi

echo "Setup complete! You may want to reboot your system."
