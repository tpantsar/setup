#!/bin/bash
# Clone the dotfiles repository and set up symlinks using GNU Stow

REPO_URL="git@github.com:tpantsar/dotfiles.git"
REPO_NAME="dotfiles"
REPO_TARGET="$HOME/$REPO_NAME"

if [ -d "$REPO_TARGET" ]; then
  echo "Repository '$REPO_TARGET' already exists. Skipping clone"
else
  git clone "$REPO_URL" "$REPO_TARGET"
fi

if [ -d "$REPO_TARGET" ]; then
  ~/dotfiles/bin/stoww
else
  echo "Failed to clone dotfiles repository and create symlinks."
  exit 1
fi
