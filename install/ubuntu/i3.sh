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
