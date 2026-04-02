#!/usr/bin/env bash

if ! command -v betterlockscreen &>/dev/null; then
  echo "Installing betterlockscreen dependencies ..."
  sudo apt install -y imagemagick autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev

  echo "Cloning i3lock-color to ~/i3lock-color ..."
  git clone --depth=1 https://github.com/Raymo111/i3lock-color.git ~/i3lock-color
  cd ~/i3lock-color
  ./install-i3lock-color.sh

  echo "Installing betterlockscreen ..."
  wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

  echo "Setting background for betterlockscreen ..."
  betterlockscreen -u ~/.config/wallpapers/lockscreen2.jpg
else
  echo "betterlockscreen is already installed"
  exit 0
fi
