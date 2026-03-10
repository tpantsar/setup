#!/bin/bash

# i3 window manager
if ! command -v i3 &>/dev/null; then
  # echo "Installing i3 from source ..."
  # git clone --depth=1 --branch stable --single-branch https://github.com/i3/i3.git ~/i3
  # cd ~/i3
  # git checkout stable
  echo "Installing i3 with apt package manager..."
  sudo apt-get update
  sudo apt-get install -y i3
else
  echo "i3 is already installed"
fi

# betterlockscreen
if ! command -v betterlockscreen &>/dev/null; then
  echo "Installing betterlockscreen dependencies ..."
  sudo apt install imagemagick
  sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev

  echo "Cloning i3lock-color ..."
  git clone --depth=1 https://github.com/Raymo111/i3lock-color.git ~/i3lock-color
  cd ~/i3lock-color
  ./install-i3lock-color.sh

  echo "Installing betterlockscreen ..."
  wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

  echo "Setting background for betterlockscreen ..."
  betterlockscreen -u ~/.config/backgrounds/lockscreen2.jpg
else
  echo "betterlockscreen is already installed"
fi

# i3-resurrect - https://github.com/JonnyHaystack/i3-resurrect
if ! command -v i3-resurrect &>/dev/null; then
  echo "Installing i3-resurrect from source ..."

  # Clone and build i3-resurrect from source
  git clone --depth=1 git@github.com:JonnyHaystack/i3-resurrect.git ~/i3-resurrect
  cd ~/i3-resurrect
  python3 -m venv .venv
  source .venv/bin/activate
  pip3 install .

  # Test i3-resurrect executable
  ~/i3-resurrect/.venv/bin/i3-resurrect --version

  # Copy i3-resurrect executable to PATH
  sudo cp ~/i3-resurrect/.venv/bin/i3-resurrect ~/.local/bin/
else
  echo "i3-resurrect is already installed"
fi

# autorandr - https://github.com/phillipberndt/autorandr
if ! command -v autorandr &>/dev/null; then
  echo "Installing autorandr from source ..."

  # Clone and build autorandr from source
  git clone --depth=1 https://github.com/phillipberndt/autorandr.git ~/autorandr
  cd ~/autorandr
  python3 -m venv .venv
  source .venv/bin/activate
  pip3 install .

  # Test autorandr executable
  ~/autorandr/.venv/bin/autorandr --version

  # Copy autorandr executable to PATH
  sudo cp ~/autorandr/.venv/bin/autorandr ~/.local/bin/
else
  echo "autorandr is already installed"
fi
