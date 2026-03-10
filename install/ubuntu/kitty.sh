#!/bin/bash

# Install kitty - https://sw.kovidgoyal.net/kitty/binary/
# Do not copy the kitty binary out of the installation folder.
# If you want to add it to your PATH, create a symlink in ~/.local/bin or /usr/bin or wherever.

if ! command -v kitty &>/dev/null; then
  echo "Installing kitty ..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

  # Add symlink to kitty executable
  ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
  which kitty
  kitty --version
  echo "kitty installation complete."
else
  echo "kitty is already installed"
fi
