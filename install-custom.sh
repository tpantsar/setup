#!/bin/bash
# This script installs custom packages and tools for system setup.

# Install kitty - https://sw.kovidgoyal.net/kitty/binary/
if ! command -v kitty &> /dev/null; then
  echo "Installing kitty..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
  echo "kitty is already installed"
fi

# Install lazygit - https://github.com/jesseduffield/lazygit?tab=readme-ov-file#ubuntu
if ! command -v lazygit &> /dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
else
  echo "lazygit is already installed"
fi

# Install starship - https://github.com/starship/starship?tab=readme-ov-file#step-1-install-starship
if ! command -v starship &> /dev/null; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
else
  echo "starship is already installed"
fi