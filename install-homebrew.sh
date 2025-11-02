#!/bin/bash

# This script installs:
# homebrew package manager
# sesh (terminal session manager)
# lf (terminal file manager)

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed"
fi

# Install sesh
if ! command -v sesh &>/dev/null; then
  echo "Installing sesh ..."
  brew install sesh
else
  echo "sesh is already installed"
fi

# Install gum
if ! command -v gum &>/dev/null; then
  echo "Installing gum ..."
  brew install gum
else
  echo "gum is already installed"
fi

# Install lf (terminal file manager)
# https://github.com/gokcehan/lf
if ! command -v lf &>/dev/null; then
  echo "Installing lf (terminal file manager) ..."
  brew install lf
else
  echo "lf is already installed"
fi
