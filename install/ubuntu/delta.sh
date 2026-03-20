#!/bin/bash

REPO_PATH="${REPO_PATH:-$HOME/setup}"

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  $REPO_PATH/install/ubuntu/homebrew.sh
fi

if ! command -v delta &>/dev/null; then
  echo "Installing git-delta ..."
  brew install git-delta
else
  echo "git-delta is already installed"
fi
