#!/bin/bash

if [ -f "/usr/share/nvm/init-nvm.sh" ]; then
  echo "nvm is already installed system-wide"
  source /usr/share/nvm/init-nvm.sh
  echo "nvm version: $(nvm --version)"
else
  echo "nvm is not installed system-wide"
fi

# Install nvm (Node Version Manager) - https://github.com/nvm-sh/nvm#installing-and-updating
# nvm is a shell function, not a standalone binary
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  echo "nvm is already installed for the user"
else
  echo "Installing nvm (Node Version Manager) ..."
  LATEST_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${LATEST_VERSION}/install.sh" | bash
fi

nvm install --lts
nvm install-latest-npm
nvm use --lts

# Install npm packages
npm install -g @openai/codex
