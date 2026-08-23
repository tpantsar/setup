#!/bin/bash
# https://github.com/iwe-org/iwe
# https://iwe.md/docs/getting-started/installation/

set -e

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1"
    exit 1
  }
}

need_cmd git
need_cmd cargo

dir="$HOME/code/iwe"

# Create symlinks to iwe cli, lsp, mcp server
symlinks() {
  sudo ln -sf "$dir/target/release/iwe" /usr/local/bin/iwe
  sudo ln -sf "$dir/target/release/iwes" /usr/local/bin/iwes
  sudo ln -sf "$dir/target/release/iwec" /usr/local/bin/iwec
}

clone() {
  git clone git@github.com:iwe-org/iwe.git $dir
  cd $dir
  cargo build --release
  symlinks
}

update() {
  git -C "$dir" pull --rebase --autostash
  cd $dir
  cargo build --release
  symlinks
}

# Get latest iwe version from GitHub. Example: 0.20.0
LATEST_VERSION=$(curl -s "https://api.github.com/repos/iwe-org/iwe/releases/latest" | grep -Po '"tag_name": *"iwe-v\K[^"]*')

# Get installed iwe version, if present
INSTALLED_VERSION=""
if command -v iwe &>/dev/null; then
  INSTALLED_VERSION=$(iwe --version | awk '{print $2}')
fi

# Install or update iwe if needed
if [ -z "$INSTALLED_VERSION" ]; then
  echo "Installing iwe $LATEST_VERSION..."
  clone
elif [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating iwe from $INSTALLED_VERSION to $LATEST_VERSION..."
  update
else
  echo "iwe is already up to date ($INSTALLED_VERSION)"
fi

echo "iwe path: $(command -v iwe)"
echo "iwe version: $(iwe --version)"
