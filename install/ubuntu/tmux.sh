#!/bin/bash
# Install tmux from source.
# Troubleshooting:
# tmux open terminal failed: not a terminal
# https://stackoverflow.com/questions/25207909/tmux-open-terminal-failed-not-a-terminal

source /etc/os-release

if command -v tmux &>/dev/null; then
  echo "tmux is already installed."
  exit 0
fi

# Install tmux
if [[ "$ID" == "arch" ]]; then
  yay -S --noconfirm --needed tmux
elif [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
  # sudo apt-get update
  # sudo apt-get install -y tmux
  # https://github.com/tmux/tmux/wiki/Installing#from-source-tarball
  # https://github.com/tmux/tmux/wiki/Installing#from-version-control
  git clone https://github.com/tmux/tmux.git ~/tmux-installation
  cd ~/tmux-installation
  sudo apt install -y autoconf automake pkg-config libevent-dev ncurses-dev build-essential bison
  sh autogen.sh
  ./configure --enable-static
  make && sudo make install
  tmux -V
  echo "tmux installed successfully!"
else
  echo "Other distro: $ID"
  echo "Unsupported distribution. Exiting."
  exit 1
fi

# Check if tmux is installed
if ! command -v tmux &>/dev/null; then
  echo "tmux installation failed."
  exit 1
fi
