#!/bin/bash
set -euo pipefail

DIR="$HOME/.tmuxifier"
REPO="https://github.com/tpantsar/tmuxifier.git"

echo "==> Checking tmuxifier installation at $DIR"

if [[ ! -f "$DIR/bin/tmuxifier" ]]; then
  echo "tmuxifier executable is missing."
  echo "Removing existing directory and cloning tmuxifier..."
  rm -rf "$DIR"
  git clone https://github.com/tpantsar/tmuxifier.git "$DIR"
else
  echo "tmuxifier executable found."
fi

echo "==> Updating tmuxifier"
git -C "$DIR" pull --rebase --autostash

echo "Creating symlink: /usr/local/bin/tmuxifier -> $DIR/bin/tmuxifier"
sudo ln -sf "$DIR/bin/tmuxifier" /usr/local/bin/tmuxifier

if [[ -d "$HOME/dotfiles" && ! -d "$DIR/layouts" ]]; then
  echo "==> Restowing dotfiles due to missing tmuxifier layouts"
  stow --dir="$HOME/dotfiles" --target="$HOME" .
fi

echo "tmuxifier installation/update complete."
