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

# bat -> batcat symlink
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

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
  git clone --depth=1 https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
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

# i3 window manager
if ! command -v i3 &> /dev/null; then
  echo "Installing i3 from source ..."
  git clone --depth=1 --branch stable --single-branch https://github.com/i3/i3.git ~/i3
  cd ~/i3
  git checkout stable
else
  echo "i3 is already installed"
fi

# Install uv (Python package manager) - https://docs.astral.sh/uv/
if ! command -v uv &> /dev/null; then
  echo "Installing uv ..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  echo "uv is already installed"
fi

# Install nvm (Node Version Manager) - https://github.com/nvm-sh/nvm#installing-and-updating
if ! command -v nvm &> /dev/null; then
  echo "Installing nvm ..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
else
  echo "nvm is already installed"
fi

# betterlockscreen
if ! command -v betterlockscreen &> /dev/null; then
  echo "Installing betterlockscreen dependencies ..."
  sudo apt install imagemagick
  sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev

  echo "Cloning i3lock-color ..."
  git clone --depth=1 https://github.com/Raymo111/i3lock-color.git ~/i3lock-color
  cd ~/i3lock-color
  ./install-i3lock-color.sh

  echo "Installing betterlockscreen ..."
  wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

  echo "Setting background for betterlockscreen ..."
  betterlockscreen -u ~/.config/backgrounds/lockscreen2.jpg
else
  echo "betterlockscreen is already installed"
fi

# yazi - https://github.com/sxyazi/yazi
if ! command -v yazi &> /dev/null; then
  echo "Installing yazi ..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  rustup update

  # Clone and build yazi from source
  git clone --depth=1 https://github.com/sxyazi/yazi.git ~/yazi
  cd ~/yazi
  cargo build --release --locked

  # Add yazi and ya to your $PATH
  sudo mv target/release/yazi target/release/ya /usr/local/bin/
else
  echo "yazi is already installed"
fi
