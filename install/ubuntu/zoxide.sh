#!/bin/bash

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if ! command -v zoxide >/dev/null 2>&1; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "zoxide is already installed"
fi
