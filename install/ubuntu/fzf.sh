#!/bin/bash
# https://github.com/junegunn/fzf?tab=readme-ov-file#using-git

FORCE="${FORCE:-0}"

dir="$HOME/.fzf"

if command -v fzf &>/dev/null 2>&1 && [ "$FORCE" -eq 0 ]; then
  echo "fzf is already installed. Skipping."
  echo "fzf path: $(which fzf)"
  echo "fzf version: $(fzf --version)"
  exit 0
fi

if ! command -v git &>/dev/null; then
  echo "Git is not installed. Installing it..."
  sudo apt install -y git
fi

if [ -d "$dir" ]; then
  echo "Updating existing $dir directory ..."
  git -C "$dir" pull --rebase --autostash --depth 1 origin master
  git -C "$dir" checkout master
else
  echo "Cloning and installing fzf ..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$dir"
fi

~/.fzf/install

# Create symlinks
sudo ln -s ~/.fzf/bin/fzf /usr/local/bin/fzf
sudo ln -s ~/.fzf/bin/fzf-tmux /usr/local/bin/fzf-tmux
sudo ln -s ~/.fzf/bin/fzf-preview.sh /usr/local/bin/fzf-preview.sh

echo "fzf path: $(which fzf)"
echo "fzf version: $(fzf --version)"
