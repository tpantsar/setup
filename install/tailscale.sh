#!/bin/bash

if command -v tailscale &>/dev/null; then
  echo "tailscale is already installed. Skipping."
  exit 0
fi

echo "Installing tailscale ..."
curl -fsSL https://tailscale.com/install.sh | sh
echo "tailscale installed. Try running: sudo tailscale up"

# sudo tailscale up
# tailscale completion zsh
