#!/usr/bin/env bash

# autorandr - https://github.com/phillipberndt/autorandr
if ! command -v autorandr &>/dev/null; then
  echo "Cloning and installing autorandr from git source..."
  git clone --depth=1 https://github.com/phillipberndt/autorandr.git ~/autorandr
  cd ~/autorandr
  sudo apt install -y python3

  echo "Creating virtual environment for autorandr..."
  python3 -m venv .venv
  source .venv/bin/activate

  echo "Installing autorandr with pip3..."
  pip3 install .

  # Test autorandr executable
  ~/autorandr/.venv/bin/autorandr --version

  # Copy autorandr executable to PATH
  sudo cp ~/autorandr/.venv/bin/autorandr ~/.local/bin/
else
  echo "autorandr is already installed"
  exit 0
fi
