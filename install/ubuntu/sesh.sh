#!/bin/bash

REPO_PATH="${REPO_PATH:-$HOME/setup}"

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  $REPO_PATH/install/ubuntu/homebrew.sh
fi

if ! command -v sesh &>/dev/null; then
  echo "Installing sesh ..."
  brew install sesh
else
  echo "sesh is already installed"
fi
