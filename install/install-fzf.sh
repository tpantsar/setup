#!/bin/bash
# https://github.com/junegunn/fzf?tab=readme-ov-file#using-git

if command -v fzf &>/dev/null; then
  echo "fzf is already installed. Skipping."
  return
fi

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Create symlinks
sudo ln -s ~/.fzf/bin/fzf /usr/local/bin/fzf
sudo ln -s ~/.fzf/bin/fzf-tmux /usr/local/bin/fzf-tmux
sudo ln -s ~/.fzf/bin/fzf-preview.sh /usr/local/bin/fzf-preview.sh
