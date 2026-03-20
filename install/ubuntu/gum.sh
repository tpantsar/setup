#!/bin/bash

REPO_PATH="${REPO_PATH:-$HOME/setup}"

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  $REPO_PATH/install/ubuntu/homebrew.sh
fi

if ! command -v gum &>/dev/null; then
  echo "Installing gum ..."
  brew install gum
else
  echo "gum is already installed"
fi
