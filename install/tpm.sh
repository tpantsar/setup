#!/usr/bin/env bash
# Tmux plugin manager

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
  echo "TPM is already installed in $TPM_DIR"
else
  echo "Installing TPM (Tmux Plugin Manager) to $TPM_DIR ..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "TPM installed successfully to $TPM_DIR"
fi
