#!/bin/bash

source /etc/os-release
set -e

# Install tmux
if [[ "$ID" == "arch" ]]; then
  yay -S --noconfirm --needed tmux
elif [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
  sudo apt-get update
  sudo apt-get install -y tmux
  echo "tmux installed successfully!"
else
  echo "Other distro: $ID"
  echo "Unsupported distribution. Exiting."
  exit 1
fi

# Check if tmux is installed
if ! command -v tmux &>/dev/null; then
  echo "tmux installation failed."
  exit 1
fi

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
  echo "TPM is already installed in $TPM_DIR"
else
  echo "Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "TPM installed successfully!"
fi

# Install tmuxifier - https://github.com/jimeh/tmuxifier
if ! command -v tmuxifier &>/dev/null; then
  echo "tmuxifier is not installed. Installing..."
  git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
  export PATH="$HOME/.tmuxifier/bin:$PATH"
  echo "tmuxifier installed successfully!"
else
  echo "tmuxifier is already installed."
fi
