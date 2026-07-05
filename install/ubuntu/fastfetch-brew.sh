#!/bin/bash

# If fastfetch is not packaged for your distribution or an outdated version is packaged, linuxbrew is a good alternative
# https://github.com/fastfetch-cli/fastfetch

REPO_PATH="${REPO_PATH:-$HOME/setup}"

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  $REPO_PATH/install/ubuntu/homebrew.sh
fi

if ! command -v fastfetch &>/dev/null; then
  echo "Installing fastfetch ..."
  brew install fastfetch
else
  echo "fastfetch is already installed"
fi
