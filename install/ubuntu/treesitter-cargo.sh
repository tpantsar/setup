#!/bin/bash

# Install tree-sitter-cli with cargo-binstall (Binary installation for rust projects).
# https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md
# https://github.com/cargo-bins/cargo-binstall

# You can also download a pre-built binary for your platform from the releases page.
# https://github.com/tree-sitter/tree-sitter/releases/latest

if ! command -v cargo &>/dev/null; then
  echo "cargo not found. Installing cargo from apt ..."
  sudo apt update
  sudo apt install -y cargo
  echo "Installed cargo from apt, version:"
  echo "$(cargo --version)"
fi

if ! command -v tree-sitter >/dev/null 2>&1; then
  echo "Installing cargo-binstall (Binary installation for rust projects)..."
  cargo install binstall

  # Build from source
  # cargo install --locked tree-sitter-cli

  echo "Installing tree-sitter-cli with cargo binstall..."
  cargo binstall tree-sitter-cli
else
  echo "tree-sitter is already installed"
fi

echo "tree-sitter path: $(command -v tree-sitter)"
echo "tree-sitter version: $(tree-sitter --version)"
