#!/bin/bash

if ! command -v cargo &>/dev/null; then
  echo "Installing cargo from apt ..."
  sudo apt install -y cargo
fi

# https://github.com/sharkdp/fd?tab=readme-ov-file#installation
if ! command -v fd &>/dev/null; then
  echo "Installing fd with cargo ..."
  cargo install fd-find
else
  echo "fd is already installed"
fi

echo "fd path: $(which fd)"
echo "fd version: $(fd --version)"
