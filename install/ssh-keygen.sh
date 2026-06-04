#!/bin/bash
# Generate a local SSH keypair if one is missing.

set -eEo pipefail

SSH_METHOD="${SSH_METHOD:-ed25519}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_${SSH_METHOD}}"
PUB_KEY="${SSH_KEY}.pub"
EMAIL="${EMAIL:-$(git config --get user.email 2>/dev/null || true)}"
EMAIL="${EMAIL:-tomi.pantsar@gmail.com}"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ ! -f "$SSH_KEY" ]]; then
  echo "Generating a new SSH key at $SSH_KEY..."
  ssh-keygen -t "$SSH_METHOD" -C "$EMAIL" -f "$SSH_KEY" -N ""
  chmod 600 "$SSH_KEY"
else
  echo "SSH key already exists at $SSH_KEY"
fi

if [[ ! -f "$PUB_KEY" ]]; then
  echo "Public key missing; regenerating $PUB_KEY from private key..."
  ssh-keygen -y -f "$SSH_KEY" >"$PUB_KEY"
fi

chmod 644 "$PUB_KEY"
echo "SSH public key is ready at $PUB_KEY"
