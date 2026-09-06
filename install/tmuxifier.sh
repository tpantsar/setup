#!/bin/bash
set -euo pipefail

dir="$HOME/.tmuxifier"
repo="https://github.com/tpantsar/tmuxifier.git"

echo "==> Checking tmuxifier installation at $dir"

if [[ ! -f "$dir/bin/tmuxifier" ]]; then
  echo "tmuxifier executable is missing."
  echo "Removing existing directory and cloning tmuxifier..."
  rm -rf "$dir"
  git clone "$repo" "$dir"
else
  echo "tmuxifier executable found."
fi

echo "==> Updating tmuxifier"
git -C "$dir" pull --rebase --autostash

echo "Creating symlink: /usr/local/bin/tmuxifier -> $dir/bin/tmuxifier"
sudo ln -sf "$dir/bin/tmuxifier" /usr/local/bin/tmuxifier

if [[ -d "$HOME/dotfiles" && ! -d "$dir/layouts" ]]; then
  echo "==> Restowing dotfiles due to missing tmuxifier layouts"
  stow --dir="$HOME/dotfiles" --target="$HOME" .
fi

echo "tmuxifier installation/update complete."
