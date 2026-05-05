#!/usr/bin/env bash
# https://www.agwa.name/projects/git-crypt/

# Ensure git is installed
if ! command -v git &>/dev/null; then
  echo "git not found. Installing..."
  sudo apt update
  sudo apt install -y git
fi

# Get latest git-crypt version from GitHub
# Other source: https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.8.0.tar.gz
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/AGWA/git-crypt/releases/latest" | grep -Po '"tag_name": *"\K[^"]*')

# Get installed git-crypt version, if present
INSTALLED_VERSION=""
if command -v git-crypt &>/dev/null; then
  INSTALLED_VERSION=$(git-crypt version | awk '{print $2}')
fi

# Install or update git-crypt if needed
if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing git-crypt $LATEST_VERSION..."
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating git-crypt from $INSTALLED_VERSION to $LATEST_VERSION..."
else
  echo "git-crypt is already up to date ($INSTALLED_VERSION)"
  exit 0
fi

# install to a temp directory first, then move to /usr/local/bin with sudo permissions
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR" || exit 1

# This URL downloads a single Linux executable, not a .tar.gz archive
# https://github.com/AGWA/git-crypt/releases/download/0.8.0/git-crypt-0.8.0-linux-x86_64
curl -fL -o git-crypt "https://github.com/AGWA/git-crypt/releases/download/${LATEST_VERSION}/git-crypt-${LATEST_VERSION}-linux-x86_64"
chmod +x git-crypt
sudo install -m 0755 git-crypt /usr/local/bin/git-crypt

echo "git-crypt path: $(command -v git-crypt)"
echo "git-crypt version: $(git-crypt version)"
