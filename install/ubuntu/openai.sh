#!/usr/bin/env bash
# https://developers.openai.com/api/docs/libraries/openai-cli#installation

REPO_PATH="${REPO_PATH:-$HOME/setup}"

if ! command -v brew &>/dev/null; then
  $REPO_PATH/install/ubuntu/homebrew.sh
fi

if ! command -v openai &>/dev/null; then
  echo "Installing openai CLI with brew..."
  brew install openai/tools/openai
else
  echo "openai is already installed."
  echo "openai path: $(command -v openai)"
  echo "openai version: $(openai --version)"
fi
