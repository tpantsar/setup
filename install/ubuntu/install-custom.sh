#!/bin/bash
# This script installs custom packages and tools for system setup.

# Return on errors
set -e

# Ensure that local/bin directory exists for custom executables
mkdir -p ~/.local/bin/

# Neovim build - https://github.com/neovim/neovim/blob/master/BUILD.md
# https://github.com/neovim/neovim/blob/stable/BUILD.md#build-prerequisites
if ! command -v nvim &>/dev/null; then
  echo "Building and installing Neovim (stable release) from source"
  rm -rf ~/neovim/

  # Shallow clone only the stable branch
  git clone --branch stable --single-branch --depth 1 https://github.com/neovim/neovim ~/neovim
  cd ~/neovim

  # Build with Release type
  make CMAKE_BUILD_TYPE=Release

  # Verify build type after compilation
  ./build/bin/nvim --version | grep ^Build

  # Install and check version
  sudo make install
  nvim -V1 -v
else
  echo "Neovim is already installed"
fi

# bat -> batcat symlink
if ! command -v bat &>/dev/null; then
  ln -s /usr/bin/batcat ~/.local/bin/bat
fi

# Install oh-my-zsh - https://ohmyz.sh/#basic-installation
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh is already installed"
fi

# Install zoxide - https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if ! command -v zoxide &>/dev/null; then
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

# Alacritty
if ! command -v alacritty &>/dev/null; then
  echo "Installing alacritty..."
  cargo install alacritty

  # Test alacritty executable
  which alacritty
  alacritty --version
else
  echo "alacritty is already installed"
fi

# eza: A modern replacement for ls - https://github.com/eza-community/eza/tree/main
if ! command -v eza &>/dev/null; then
  echo "Installing eza..."
  cargo install eza

  # Test eza executable
  which eza
  eza --version
else
  echo "eza is already installed"
fi

if ! command -v tree-sitter &>/dev/null; then
  echo "Installing tree-sitter..."
  cargo install --locked tree-sitter-cli
  which tree-sitter
else
  echo "tree-sitter is already installed"
fi

# Install kitty - https://sw.kovidgoyal.net/kitty/binary/
# Do not copy the kitty binary out of the installation folder.
# If you want to add it to your PATH, create a symlink in ~/.local/bin or /usr/bin or wherever.
if ! command -v kitty &>/dev/null; then
  echo "Installing kitty..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

  # Add symlink to kitty executable
  ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
  which kitty
  kitty --version
else
  echo "kitty is already installed"
fi

# Install lazygit - https://github.com/jesseduffield/lazygit?tab=readme-ov-file#ubuntu
if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/

  # Test lazygit executable
  which lazygit
  lazygit --version
else
  echo "lazygit is already installed"
fi

# Install lazydocker - https://github.com/jesseduffield/lazydocker?tab=readme-ov-file#ubuntu
if ! command -v lazydocker &>/dev/null; then
  echo "Installing lazydocker..."
  LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazydocker.tar.gz lazydocker
  sudo install lazydocker -D -t /usr/local/bin/

  # Test lazydocker executable
  which lazydocker
  lazydocker --version
else
  echo "lazydocker is already installed"
fi

# Install onedrive - https://github.com/abraunegg/onedrive/blob/master/docs/install.md
# https://github.com/abraunegg/onedrive/blob/master/docs/advanced-usage.md#configuring-the-client-to-use-multiple-onedrive-accounts--configurations
if ! command -v onedrive &>/dev/null; then
  echo "Installing build dependencies for onedrive ..."
  sudo apt install build-essential
  sudo apt install libcurl4-openssl-dev libsqlite3-dev pkg-config git curl systemd-dev libdbus-1-dev
  sudo apt install libnotify-dev

  if ! ls ~/dlang/ | grep -q '^dmd-'; then
    echo "Installing dmd compiler ..."
    curl -fsS https://dlang.org/install.sh | bash -s dmd

    latest_dmd=$(find ~/dlang -maxdepth 1 -type d -name 'dmd-*' | sed 's:.*/::' | sort -V | tail -n 1)

    # Activate the latest DMD version
    if [[ -n "$latest_dmd" && -f ~/dlang/$latest_dmd/activate ]]; then
      source ~/dlang/$latest_dmd/activate
      echo "Activated DMD version: $latest_dmd"
    else
      echo "No valid DMD version found to activate."
      exit 1
    fi
  else
    echo "dmd compiler is already installed, skipping ..."
  fi

  echo "Cloning onedrive git repository ..."
  git clone https://github.com/abraunegg/onedrive.git ~/onedrive
  cd ~/onedrive
  ./configure
  make clean
  make
  sudo make install

  # Test onedrive executable
  which onedrive
  onedrive --version

  # Enable onedrive on systemctl
  sudo ps aufxw | grep onedrive
  systemctl --user enable --now onedrive

  echo "Deactivating dmd environment ..."
  deactivate

  echo "Configuring Personal OneDrive account ..."
  mkdir -p ~/.config/onedrive-personal/
  wget https://raw.githubusercontent.com/abraunegg/onedrive/master/config -O ~/.config/onedrive-personal/config

  # Update sync_dir in config file to point to your desired sync location
  sed -i 's|^#\? *sync_dir *=.*|sync_dir = "~/OneDrive-Personal"|' ~/.config/onedrive-personal/config
  sed -i 's|^#\? *skip_dir *=.*|skip_dir = ".*Temp.*"|' ~/.config/onedrive-personal/config

  # Sync the OneDrive account data
  # --sync does a one-time sync
  # --monitor keeps the application running and monitoring for changes both local and remote
  onedrive --confdir ~/.config/onedrive-personal/ --monitor --verbose

  # Enable service
  sudo cp /usr/lib/systemd/user/onedrive.service /usr/lib/systemd/user/onedrive-personal.service
  sudo chmod 644 /usr/lib/systemd/user/onedrive-personal.service

  # temp file permissions
  sudo chown "$USER":"$USER" /usr/lib/systemd/user/

  # Edit the new systemd file, updating the line beginning with ExecStart so that the confdir mirrors the one you used above:
  # The ~ must be manually expanded when editing systemd file.
  sed -i 's|^ExecStart=.*|ExecStart=/usr/local/bin/onedrive --confdir '"$HOME"'/.config/onedrive-personal --monitor|' /usr/lib/systemd/user/onedrive-personal.service

  # Enable the new systemd service
  systemctl --user enable onedrive-personal.service
  systemctl --user start onedrive-personal.service

  # Check status
  systemctl --user status onedrive-personal.service
else
  echo "onedrive is already installed"
fi

# Install starship - https://github.com/starship/starship?tab=readme-ov-file#step-1-install-starship
if ! command -v starship &>/dev/null; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
else
  echo "starship is already installed"
fi

# i3 window manager
if ! command -v i3 &>/dev/null; then
  echo "Installing i3 from source ..."
  git clone --depth=1 --branch stable --single-branch https://github.com/i3/i3.git ~/i3
  cd ~/i3
  git checkout stable
else
  echo "i3 is already installed"
fi

# Install uv (Python package manager) - https://docs.astral.sh/uv/
if ! command -v uv &>/dev/null; then
  echo "Installing uv ..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  echo "uv is already installed"
fi

# Install nvm (Node Version Manager) - https://github.com/nvm-sh/nvm#installing-and-updating
# Check if nvm is installed by checking the init script
# nvm is a shell function, not a standalone binary
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  echo "nvm is already installed"
else
  echo "Installing nvm (Node Version Manager) ..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# betterlockscreen
if ! command -v betterlockscreen &>/dev/null; then
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
# https://yazi-rs.github.io/docs/installation#source
if ! command -v yazi &>/dev/null; then
  echo "Installing yazi ..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  rustup update

  # Clone and build yazi from source
  git clone --depth=1 https://github.com/sxyazi/yazi.git ~/yazi
  cd ~/yazi
  cargo build --release --locked

  # Add yazi and ya to your $PATH
  sudo mv target/release/yazi target/release/ya /usr/local/bin/

  # Check version
  yazi -V
else
  echo "yazi is already installed"
fi

# i3-resurrect - https://github.com/JonnyHaystack/i3-resurrect
if ! command -v i3-resurrect &>/dev/null; then
  echo "Installing i3-resurrect from source ..."

  # Clone and build i3-resurrect from source
  git clone --depth=1 git@github.com:JonnyHaystack/i3-resurrect.git ~/i3-resurrect
  cd ~/i3-resurrect
  python3 -m venv .venv
  source .venv/bin/activate
  pip3 install .

  # Test i3-resurrect executable
  ~/i3-resurrect/.venv/bin/i3-resurrect --version

  # Copy i3-resurrect executable to PATH
  sudo cp ~/i3-resurrect/.venv/bin/i3-resurrect ~/.local/bin/
else
  echo "i3-resurrect is already installed"
fi

# autorandr - https://github.com/phillipberndt/autorandr
if ! command -v autorandr &>/dev/null; then
  echo "Installing autorandr from source ..."

  # Clone and build autorandr from source
  git clone --depth=1 https://github.com/phillipberndt/autorandr.git ~/autorandr
  cd ~/autorandr
  python3 -m venv .venv
  source .venv/bin/activate
  pip3 install .

  # Test autorandr executable
  ~/autorandr/.venv/bin/autorandr --version

  # Copy autorandr executable to PATH
  sudo cp ~/autorandr/.venv/bin/autorandr ~/.local/bin/
else
  echo "autorandr is already installed"
fi

# Docker - https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
if ! command -v docker &>/dev/null; then
  echo "Installing docker ..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh

  # Test docker executable
  /usr/bin/docker version

  # Add sudo permissions to your user
  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  groups | grep -i docker
  /usr/bin/docker ps
else
  echo "docker is already installed"
fi
