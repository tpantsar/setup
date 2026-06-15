#!/bin/bash

# bat -> batcat symlink
if ! command -v bat >/dev/null 2>&1 || ! command -v batcat >/dev/null 2>&1; then
  echo "Installing bat from apt"
  sudo apt install -y bat
  ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
  echo "Symlink created: $HOME/.local/bin/bat -> /usr/bin/batcat"
  echo "bat installed and symlinked to batcat"
else
  echo "bat is already installed"
fi

echo "bat version: $(bat --version)"
