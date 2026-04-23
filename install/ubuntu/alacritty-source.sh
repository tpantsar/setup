#!/usr/bin/env bash

FORCE="${FORCE:-0}"

if command -v alacritty >/dev/null 2>&1 && [ "$FORCE" -eq 0 ]; then
  echo "alacritty is already installed. Exiting."
  exit 0
fi

if ! command -v rustup &>/dev/null; then
  echo "rustup not found. Installing rustup binary ..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# https://github.com/alacritty/alacritty/blob/master/INSTALL.md#prerequisites
rustup override set stable
rustup update stable

# Get latest alacritty version from GitHub (v0.17.0)
# ALACRITTY_VERSION=$(curl -s "https://api.github.com/repos/alacritty/alacritty/releases/latest" | grep -Po '"tag_name": *"\K[^"]*')

# https://github.com/alacritty/alacritty/blob/master/INSTALL.md#manual-installation
git clone https://github.com/alacritty/alacritty.git ~/alacritty
cd ~/alacritty
# git checkout "$ALACRITTY_VERSION"

# dependencies
sudo apt install -y cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

# building
cargo build --release

# There are some extra things you might want to set up after installing Alacritty.
# All the post build instruction assume you're still inside the Alacritty repository.

# Add desktop entry
# https://github.com/alacritty/alacritty/blob/master/INSTALL.md#desktop-entry
echo "Adding Desktop Entry ..."
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

# Manual page
sudo apt install -y gzip scdoc
sudo mkdir -p /usr/local/share/man/man1
sudo mkdir -p /usr/local/share/man/man5
scdoc <extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz >/dev/null
scdoc <extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz >/dev/null
scdoc <extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz >/dev/null
scdoc <extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz >/dev/null

# Shell completions
# https://github.com/alacritty/alacritty/blob/master/INSTALL.md#shell-completions
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >>${ZDOTDIR:-~}/.zshrc

# copy the completion file
cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty
