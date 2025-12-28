#!/bin/bash

CONFIG_DIR="$HOME/.config/onedrive-personal"

if ! command -v onedrive &>/dev/null; then
  echo "OneDrive client not found. Please install it first."
  exit 1
fi

if [ ! -f "$CONFIG_DIR/config" ]; then
  echo "Setting up OneDrive personal config..."
  mkdir -p "$CONFIG_DIR"
  wget https://raw.githubusercontent.com/abraunegg/onedrive/master/config -O "$CONFIG_DIR/config"

  sed -i 's|^#\? *sync_dir *=.*|sync_dir = "~/OneDrive-Personal"|' "$CONFIG_DIR/config"
  sed -i 's|^#\? *skip_dir *=.*|skip_dir = ".*Temp.*"|' "$CONFIG_DIR/config"
  echo "OneDrive config file created."

  systemctl --user enable onedrive-personal.service || true
  systemctl --user start onedrive-personal.service || true
  echo "OneDrive service enabled and started."
else
  echo "OneDrive config already exists, skipping."
  exit 0
fi
