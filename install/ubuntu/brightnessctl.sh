#!/bin/bash

# Install brightnessctl if not present
if ! command -v brightnessctl &>/dev/null; then
  echo "Installing brightnessctl with apt ..."
  sudo apt install -y brightnessctl
fi

if command -v brightnessctl &>/dev/null; then
  sudo chmod +s /usr/bin/brightnessctl
  sudo usermod -aG video $USER
  echo "Enabled brightnessctl permissions for user $USER"
fi
