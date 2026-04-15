#!/bin/bash

REPO_PATH="${REPO_PATH:-$HOME/setup}"

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  $REPO_PATH/install/ubuntu/homebrew.sh
fi

if ! command -v glab &>/dev/null; then
  echo "Installing glab with brew..."
  brew install glab
else
  echo "glab is already installed"
fi
