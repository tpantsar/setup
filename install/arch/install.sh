#!/bin/bash

set -eEo pipefail

# Install paths
export SETUP_PATH="$HOME/setup"
export SETUP_INSTALL="$SETUP_PATH/install"

bash "$SETUP_INSTALL/arch/base.sh"

# pacman
mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/arch/packages-full.pacman" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"

# yay
mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/arch/packages.yay" | grep -v '^$')
yay -S --noconfirm --needed "${packages[@]}"
