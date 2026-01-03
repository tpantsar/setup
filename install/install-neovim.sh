#!/bin/bash

# Exit on any failure
set -eEo pipefail

if ! command -v git &>/dev/null; then
  echo "Git is not installed. Please install Git and rerun the script."
  exit 1
fi

if ! command -v make &>/dev/null; then
  echo "make is not installed. Please install make and rerun the script."
  exit 1
fi

if ! command -v cmake &>/dev/null; then
  echo "cmake is not installed. Please install cmake and rerun the script."
  exit 1
fi

# Neovim build - https://github.com/neovim/neovim/blob/master/BUILD.md
# https://github.com/neovim/neovim/blob/stable/BUILD.md#build-prerequisites
if ! command -v nvim &>/dev/null; then
  echo "Building and installing Neovim (stable release) from source"
  rm -rf ~/neovim/

  # Shallow clone only the stable branch
  git clone --branch stable --single-branch --depth 1 https://github.com/neovim/neovim ~/neovim
  cd ~/neovim

  # Build with Release type
  make CMAKE_BUILD_TYPE=Release

  # Verify build type after compilation
  ./build/bin/nvim --version | grep ^Build

  # Install and check version
  sudo make install
  nvim -V1 -v
else
  echo "Neovim is already installed"
fi
