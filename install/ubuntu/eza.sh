#!/bin/bash
# eza: A modern replacement for ls

# https://github.com/eza-community/eza/tree/main
# https://eza.rocks/
if ! command -v eza >/dev/null 2>&1; then
  echo "Installing eza..."
  sudo apt update
  sudo apt install -y gpg

  # Eza is available from deb.gierens.de and is signed with a GPG key.
  # To install eza, you need to add the repository and its GPG key to your system.
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt install -y eza

  echo "eza installed successfully"
  echo "eza installation path: $(which eza)"
  echo "eza version: $(eza --version)"
else
  echo "eza is already installed"
fi
