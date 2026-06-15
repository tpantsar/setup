#!/bin/bash

# Install brightnessctl if not present
if ! command -v brightnessctl >/dev/null 2>&1; then
  echo "Installing brightnessctl with apt ..."
  sudo apt install -y brightnessctl
else
  echo "brightnessctl is already installed"
fi

if command -v brightnessctl >/dev/null 2>&1; then
  echo "Enabling brightnessctl permissions for user $USER"
  sudo chmod +s /usr/bin/brightnessctl
  sudo usermod -aG video "$USER"
fi
