#!/bin/bash

if ! command -v cargo &>/dev/null; then
  echo "Installing cargo from apt ..."
  sudo apt install -y cargo
fi

# https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md
if ! command -v tree-sitter >/dev/null 2>&1; then
  echo "Installing tree-sitter with cargo ..."
  cargo install --locked tree-sitter-cli
  which tree-sitter
else
  echo "tree-sitter is already installed"
fi
