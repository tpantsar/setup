#!/usr/bin/env bash

set -euo pipefail

if [[ -f "/usr/share/nvm/init-nvm.sh" ]]; then
  echo "nvm is already installed system-wide"
  source /usr/share/nvm/init-nvm.sh
  echo "nvm version: $(nvm --version)"
else
  echo "nvm is not installed system-wide"
fi

export NVM_DIR="${HOME}/.nvm"
mkdir -p $NVM_DIR

# Install nvm (Node Version Manager) - https://github.com/nvm-sh/nvm#installing-and-updating
# nvm is a shell function, not a standalone binary
# nvm's default behavior installs global tools per Node version.
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  echo "Installing NVM (Node Version Manager) ..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  # LATEST_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  # curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${LATEST_VERSION}/install.sh" | bash
else
  echo "NVM is already installed"
fi

# Load nvm
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

echo "Installing latest LTS Node.js"
nvm install --lts
nvm alias default 'lts/*'
nvm use --lts

echo "Updating npm"
nvm install-latest-npm

echo
echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"
echo
echo "npm prefix: "
npm config get prefix
echo
echo "npm config: "
npm config list -l
