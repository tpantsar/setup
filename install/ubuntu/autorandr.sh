#!/usr/bin/env bash

# https://github.com/phillipberndt/autorandr
# https://github.com/tpantsar/autorandr
if ! command -v autorandr &>/dev/null; then
  echo "Cloning and installing autorandr from git source..."
  git clone --depth=1 git@github.com:tpantsar/autorandr.git ~/autorandr
  cd ~/autorandr
  sudo apt install -y python3

  echo "Creating virtual environment for autorandr..."
  python3 -m venv .venv
  source .venv/bin/activate

  echo "Installing autorandr with pip3..."
  pip3 install .

  echo "Copying autorandr executable to PATH"
  sudo cp ~/autorandr/.venv/bin/autorandr ~/.local/bin/

  echo "autorandr path: $(command -v autorandr)"
  echo "autorandr version: $(autorandr --version)"
else
  echo "autorandr is already installed"
  exit 0
fi
