#!/bin/bash
# https://github.com/junegunn/fzf?tab=readme-ov-file#using-git

if command -v fzf &>/dev/null; then
  echo "fzf is already installed. Skipping."
  echo "fzf path: $(which fzf)"
  echo "fzf version: $(fzf --version)"
  exit 0
fi

if ! command -v git &>/dev/null; then
  echo "Git is not installed. Installing it..."
  sudo apt install -y git
fi

if [ -d "$HOME/.fzf" ]; then
  echo "Updating existing ~/.fzf directory ..."
  cd "$HOME/.fzf"
  git pull --rebase --autostash --depth 1 origin master
  git checkout master
fi

echo "Cloning and installing fzf ..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Create symlinks
sudo ln -s ~/.fzf/bin/fzf /usr/local/bin/fzf
sudo ln -s ~/.fzf/bin/fzf-tmux /usr/local/bin/fzf-tmux
sudo ln -s ~/.fzf/bin/fzf-preview.sh /usr/local/bin/fzf-preview.sh

echo "fzf path: $(which fzf)"
echo "fzf version: $(fzf --version)"
