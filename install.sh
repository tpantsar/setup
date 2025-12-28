#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

source /etc/os-release

# Paths
export SETUP_PATH="$HOME/setup"
export SETUP_INSTALL="$SETUP_PATH/install"

source "$SETUP_INSTALL/utils.sh"

# Install
run_exec "$SETUP_INSTALL/clone-repo.sh"
run_exec "$SETUP_INSTALL/bypass-sudo.sh"
run_exec "$SETUP_INSTALL/add-ssh-key-gh.sh"
run_exec "$SETUP_INSTALL/install-dotfiles.sh"
#run_exec "$SETUP_INSTALL/install-luarocks.sh"
run_exec "$SETUP_INSTALL/install-tmux.sh"
run_exec "$SETUP_INSTALL/install-zsh.sh"
run_exec "$SETUP_INSTALL/install-fzf.sh"
run_exec "$SETUP_INSTALL/install-gcalcli.sh"
run_exec "$SETUP_INSTALL/setup-repos.sh"
run_exec "$SETUP_INSTALL/setup-tmux.sh"
run_exec "$SETUP_INSTALL/setup-onedrive.sh"
run_exec "$SETUP_INSTALL/set-shell.sh"
run_exec "$SETUP_INSTALL/set-default-browser.sh"

# Distro-specific installation
if [[ "$ID" == "arch" ]]; then
  echo "Arch Linux detected"
  bash "$SETUP_INSTALL/arch/install.sh"
elif [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
  echo "Ubuntu/Debian detected"
  bash "$SETUP_INSTALL/ubuntu/install.sh"
else
  echo "Other distro: $ID"
  echo "Unsupported distribution. Exiting."
  exit 1
fi

echo "Setup complete! You may want to reboot your system."
