#!/bin/bash

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed"
fi

if ! command -v sesh &>/dev/null; then
  echo "Installing sesh ..."
  brew install sesh
else
  echo "sesh is already installed"
fi

if ! command -v delta &>/dev/null; then
  echo "Installing git-delta ..."
  brew install git-delta
else
  echo "git-delta is already installed"
fi

if ! command -v gum &>/dev/null; then
  echo "Installing gum ..."
  brew install gum
else
  echo "gum is already installed"
fi

# lf (terminal file manager)
# https://github.com/gokcehan/lf
if ! command -v lf &>/dev/null; then
  echo "Installing lf (terminal file manager) ..."
  brew install lf
else
  echo "lf is already installed"
fi

if ! command -v fastfetch &>/dev/null; then
  echo "Installing fastfetch ..."
  brew install fastfetch
else
  echo "fastfetch is already installed"
fi
