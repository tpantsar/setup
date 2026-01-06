#!/bin/bash

if command -v tailscale &>/dev/null; then
  echo "tailscale is already installed. Skipping."
  exit 0
fi

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# tailscale completion zsh
