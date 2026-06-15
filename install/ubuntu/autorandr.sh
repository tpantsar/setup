#!/usr/bin/env bash

# https://github.com/phillipberndt/autorandr
# https://github.com/tpantsar/autorandr
if ! command -v autorandr &>/dev/null; then
  echo "Cloning and installing autorandr from git source..."
  git clone --depth=1 git@github.com:tpantsar/autorandr.git ~/autorandr
  cd ~/autorandr

  echo "Installing python3 and python3-venv from apt"
  sudo apt install -y python3 python3-venv

  echo "Creating virtual environment for autorandr..."
  python3 -m venv .venv
  source .venv/bin/activate

  echo "Installing autorandr with pip3..."
  echo "pip3 version: $(pip3 --version)"
  pip3 install .
else
  echo "autorandr is already installed"
fi

if [ ! -f "$HOME/.local/bin/autorandr" ]; then
  echo "Copying autorandr executable to PATH"
  sudo cp ~/autorandr/.venv/bin/autorandr ~/.local/bin/
fi

echo "autorandr path: $(command -v autorandr)"
echo "autorandr version: $(autorandr --version)"
