#!/bin/bash

set -eEo pipefail

# Install paths
export SETUP_PATH="$HOME/setup"
export SETUP_INSTALL="$SETUP_PATH/install"

# pacman
mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/arch/pacman.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"

# yay
mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/arch/yay.packages" | grep -v '^$')
yay -S --noconfirm --needed "${packages[@]}"
