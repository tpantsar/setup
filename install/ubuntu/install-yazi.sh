#!/bin/bash

# yazi - https://github.com/sxyazi/yazi
# https://yazi-rs.github.io/docs/installation#source
if ! command -v yazi &>/dev/null; then
  echo "Installing yazi ..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  rustup update

  # Clone and build yazi from source
  git clone --depth=1 https://github.com/sxyazi/yazi.git ~/yazi
  cd ~/yazi
  git pull --rebase
  cargo build --release --locked

  # Copy yazi and ya to $PATH
  sudo cp target/release/yazi target/release/ya /usr/local/bin/

  # Check version
  yazi -V
else
  echo "yazi is already installed"
fi
