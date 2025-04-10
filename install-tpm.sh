#!/bin/bash

set -e

# Check if tmux is installed (Debian/Ubuntu style)
if ! dpkg -s tmux &>/dev/null; then
  echo "tmux is not installed. Installing..."
  sudo apt update && sudo apt install -y tmux
fi

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
  echo "TPM is already installed in $TPM_DIR"
else
  echo "Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "TPM installed successfully!"
echo "Now opening tmux session and installing plugins..."

tmux new-session -d -s tpm_install_session

# NOTE: Assumes your tmux prefix is C-s. Adjust as needed.
tmux send-keys -t tpm_install_session C-s "I" C-m

tmux attach -t tpm_install_session

exit 0
