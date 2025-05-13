#!/bin/bash
# This script installs custom packages and tools for system setup.

# Neovim build - https://github.com/neovim/neovim/blob/master/BUILD.md
if ! command -v nvim &> /dev/null; then
  echo "Building and installing Neovim from source" 
  git clone --depth=1 https://github.com/neovim/neovim ~/neovim
  cd ~/neovim

  # Install stable release
  make CMAKE_BUILD_TYPE=Release

  # verify the build type after compilation
  ./build/bin/nvim --version | grep ^Build

  sudo make install
else
  echo "neovim is already installed"
fi

# Install oh-my-zsh - https://ohmyz.sh/#basic-installation
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh is already installed"
fi

# Install zoxide - https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if ! command -v zoxide &> /dev/null; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "zoxide is already installed"
fi

# Install tmuxifier - https://github.com/jimeh/tmuxifier
if ! command -v tmuxifier &>/dev/null; then
  echo "tmuxifier is not installed. Installing..."
  git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
  echo "tmuxifier installed successfully!"
else
  echo "tmuxifier is already installed."
fi

# Install kitty - https://sw.kovidgoyal.net/kitty/binary/
if ! command -v kitty &> /dev/null; then
  echo "Installing kitty..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
  echo "kitty is already installed"
fi

# Install lazygit - https://github.com/jesseduffield/lazygit?tab=readme-ov-file#ubuntu
if ! command -v lazygit &> /dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
else
  echo "lazygit is already installed"
fi

# Install starship - https://github.com/starship/starship?tab=readme-ov-file#step-1-install-starship
if ! command -v starship &> /dev/null; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
else
  echo "starship is already installed"
fi
