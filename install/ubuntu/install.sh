#!/usr/bin/env bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"

source "$SETUP_INSTALL/utils.sh"
source "$SETUP_INSTALL/ubuntu/utils.sh"

bash "$SCRIPT_DIR/base.sh"

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
