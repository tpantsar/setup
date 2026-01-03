#!/bin/bash

source /etc/os-release

REPO_URL="git@github.com:tpantsar/dotfiles.git"
REPO_NAME="dotfiles"
REPO_TARGET="$HOME/$REPO_NAME"

is_stow_installed_arch() {
  pacman -Qi "stow" &>/dev/null
}

is_stow_installed_ubuntu() {
  dpkg -s "stow" &>/dev/null
}

if [[ "$ID" == "arch" ]]; then
  if ! is_stow_installed_arch; then
    echo "Installing stow"
    sudo pacman --noconfirm --needed stow
    echo "stow installed successfully"
  fi
elif [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
  if ! is_stow_installed_ubuntu; then
    echo "Installing stow"
    sudo apt-get update
    sudo apt-get install -y stow
    echo "stow installed successfully"
  fi
else
  echo "Other distro: $ID"
  echo "Unsupported distribution. Exiting."
  exit 1
fi

cd ~ || exit 1

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL" "$REPO_TARGET"
fi

# Check if the clone was successful
if [ -d "$REPO_TARGET" ]; then
  echo "backing up old configs..."
  mv ~/.bashrc ~/.bashrc.bak
  mv ~/.zshrc ~/.zshrc.bak
  mv ~/.config/alacritty ~/.config/alacritty.bak
  mv ~/.config/kitty ~/.config/kitty.bak
  mv ~/.config/i3 ~/.config/i3.bak
  mv ~/.config/nvim ~/.config/nvim.bak
  mv ~/.config/starship.toml ~/.config/starship.toml.bak

  cd "$REPO_NAME"
  stow .
  echo "Dotfiles installed successfully."
else
  echo "Failed to clone the repository."
  exit 1
fi
