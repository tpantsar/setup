#!/bin/bash

set -eEo pipefail

mkdir -p "$HOME/.local/bin"

echo "Setting default web browser alternatives..."
sudo update-alternatives --config x-www-browser
sudo update-alternatives --config www-browser
sudo update-alternatives --config gnome-www-browser

# Install zoxide - https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if ! command -v zoxide >/dev/null 2>&1; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "zoxide is already installed"
fi

# fd: https://github.com/sharkdp/fd?tab=readme-ov-file#installation
if ! command -v fd &>/dev/null; then
  echo "Installing fd..."
  cargo install fd-find

  # Test fd executable
  which fd
  fd --version
else
  echo "fd is already installed"
fi

if ! command -v tree-sitter >/dev/null 2>&1; then
  echo "Installing tree-sitter..."
  cargo install --locked tree-sitter-cli
  which tree-sitter
else
  echo "tree-sitter is already installed"
fi
