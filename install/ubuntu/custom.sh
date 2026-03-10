#!/bin/bash

set -eEo pipefail

mkdir -p "$HOME/.local/bin"

echo "Setting default web browser alternatives..."
sudo update-alternatives --config x-www-browser
sudo update-alternatives --config www-browser
sudo update-alternatives --config gnome-www-browser

# bat -> batcat symlink
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
fi

# Install zoxide - https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if ! command -v zoxide >/dev/null 2>&1; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "zoxide is already installed"
fi

# eza: A modern replacement for ls - https://github.com/eza-community/eza/tree/main
if ! command -v eza >/dev/null 2>&1; then
  echo "Installing eza..."
  cargo install eza

  which eza
  eza --version
else
  echo "eza is already installed"
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

# Install starship - https://github.com/starship/starship?tab=readme-ov-file#step-1-install-starship
if ! command -v starship >/dev/null 2>&1; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
else
  echo "starship is already installed"
fi
