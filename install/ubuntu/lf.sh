#!/bin/bash

REPO_PATH="${REPO_PATH:-$HOME/setup}"

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  $REPO_PATH/install/ubuntu/homebrew.sh
fi

# lf (terminal file manager)
# https://github.com/gokcehan/lf
if ! command -v lf &>/dev/null; then
  echo "Installing lf (terminal file manager) ..."
  brew install lf
else
  echo "lf is already installed"
fi
