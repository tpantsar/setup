#!/bin/bash

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installation completed"
else
  echo "Homebrew is already installed"
fi

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  echo "Setting up Homebrew environment and dependencies ..."
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
  sudo apt-get install build-essential
fi
