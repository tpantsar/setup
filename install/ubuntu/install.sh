#!/bin/bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export SETUP_PATH="${SETUP_PATH:-$(cd "$SETUP_INSTALL/.." && pwd)}"

source "$SETUP_INSTALL/utils.sh"
source "$SETUP_INSTALL/ubuntu/utils.sh"

bash "$SETUP_PATH/base.sh"

mapfile -t packages < <(packages_from_file "$SETUP_INSTALL/ubuntu/packages-full.apt")
install_packages "${packages[@]}"

# Ensure ~/.local/bin exists for user-installed binaries
mkdir -p "$HOME/.local/bin"

echo "Setting default web browser alternatives..."
sudo update-alternatives --config x-www-browser
sudo update-alternatives --config www-browser
sudo update-alternatives --config gnome-www-browser

run_exec "$SETUP_INSTALL/neovim.sh"
run_exec "$SETUP_INSTALL/setup-python.sh"
run_exec "$SETUP_INSTALL/ubuntu/kitty.sh"
run_exec "$SETUP_INSTALL/ubuntu/lazygit.sh"
run_exec "$SETUP_INSTALL/ubuntu/lazydocker.sh"
run_exec "$SETUP_INSTALL/ubuntu/go.sh"

# cargo
run_exec "$SETUP_INSTALL/ubuntu/alacritty-source.sh"
run_exec "$SETUP_INSTALL/ubuntu/fd.sh"
run_exec "$SETUP_INSTALL/ubuntu/yazi.sh"
run_exec "$SETUP_INSTALL/ubuntu/treesitter.sh"

# homebrew
run_exec "$SETUP_INSTALL/ubuntu/gum.sh"
run_exec "$SETUP_INSTALL/ubuntu/lf.sh"
run_exec "$SETUP_INSTALL/ubuntu/sesh.sh"
