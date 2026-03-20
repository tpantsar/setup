#!/bin/bash

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
