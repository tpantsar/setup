#!/bin/bash

set -eEo pipefail

mkdir -p "$HOME/.local/bin"

echo "Setting default web browser alternatives..."
sudo update-alternatives --config x-www-browser
sudo update-alternatives --config www-browser
sudo update-alternatives --config gnome-www-browser

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
