#!/bin/bash

if ! command -v cargo &>/dev/null; then
  echo "Installing cargo from apt ..."
  sudo apt install -y cargo
fi

# https://github.com/alacritty/alacritty/blob/master/INSTALL.md
# https://alacritty.org/#Installation
if ! command -v alacritty &>/dev/null; then
  echo "Installing alacritty with cargo ..."
  cargo install alacritty

  # Test alacritty executable
  which alacritty
  alacritty --version
else
  echo "alacritty is already installed"
fi
