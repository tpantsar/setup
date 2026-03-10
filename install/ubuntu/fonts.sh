#!/bin/bash
# This script installs the Nerd Font on a Linux system.

# https://www.nerdfonts.com/font-downloads
# JetBrainsMono, Meslo, FiraCode, FiraMono, DroidSansMono, CascadiaMono, SourceCodePro, Hack
FONT_NAME="JetBrainsMono"
FONT_DIR="$HOME/.local/share/fonts"
ZIP_FILE="$FONT_DIR/${FONT_NAME}.zip"

# Get the latest version number from GitHub API
FONT_VERSION=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/${FONT_NAME}.zip"

# Check if font is already installed
if fc-list | grep -i "$FONT_NAME" &>/dev/null; then
  echo "$FONT_NAME Nerd Font is already installed."
  exit 0
fi

# Ensure unzip is installed
if ! command -v unzip &>/dev/null; then
  echo "unzip not found. Installing..."
  sudo apt update
  sudo apt install -y unzip
fi

# Create font directory if it doesn't exist
mkdir -p "$FONT_DIR"

# Download and install font
echo "Downloading $FONT_NAME Nerd Font..."
wget -O "$ZIP_FILE" "$FONT_URL"

echo "Extracting font..."
unzip -o "$ZIP_FILE" -d "$FONT_DIR"

echo "Cleaning up..."
rm "$ZIP_FILE"

echo "Updating font cache..."
fc-cache -fv

# Final check
if fc-list | grep -i "$FONT_NAME" &>/dev/null; then
  echo "$FONT_NAME Nerd Font installed successfully."
else
  echo "Failed to install $FONT_NAME Nerd Font."
  exit 1
fi
