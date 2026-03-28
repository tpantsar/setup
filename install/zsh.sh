#!/bin/bash
# https://gist.github.com/n1snt/2cccc8aa5f7b645a7628d3512c70deb6

# oh-my-zsh - https://ohmyz.sh/#basic-installation
if [ -d "$HOME/.oh-my-zsh" ] && command -v omz >/dev/null 2>&1; then
  echo "Oh My Zsh is already installed. Updating with omz update ..."
  omz update
else
  echo "Installing Oh My Zsh ..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install zinit (plugin manager)
# https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#install
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
