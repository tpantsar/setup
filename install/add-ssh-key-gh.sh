#!/bin/bash
# Automatically generate an SSH key (if missing) and add it to GitHub via Github CLI.

set -euo pipefail

if ! command -v gh &>/dev/null; then
  echo "GitHub CLI (gh) is not installed. Please install it first."
  exit 1
fi

PRIVATE_KEY="${HOME}/.ssh/id_ed25519"
EMAIL="${EMAIL:-$(git config user.email || echo "user@example.com")}"
TITLE="${TITLE:-$(hostname)-$(date +%Y%m%d-%H%M%S)}"
PUB_KEY="${PRIVATE_KEY}.pub"

# Generate SSH key if missing
if [[ ! -f "${PRIVATE_KEY}" ]]; then
  echo "Generating a new SSH key at ${PRIVATE_KEY}..."
  mkdir -p ~/.ssh
  ssh-keygen -t ed25519 -C "${EMAIL}" -f "${PRIVATE_KEY}" -N ""
else
  echo "SSH key already exists at ${PRIVATE_KEY}"
fi

# Authenticate with GitHub
echo "Checking GitHub authentication..."
if ! gh auth status &>/dev/null; then
  gh auth login
else
  echo "Already authenticated with GitHub."
fi

echo "Checking if SSH key is already added to GitHub..."

# compare with server: normalize to 'type base64' (drop trailing comment)
LOCAL_KEY_TWOFIELDS=$(awk '{print $1" "$2}' "$PUB_KEY")

# Pull all keys for the authenticated user via REST API
# /user/keys returns JSON with "key": "ssh-ed25519 AAAAB3...".
REMOTE_KEYS=$(gh api /user/keys --jq '.[].key' || true)

# Normalize remote keys the same way and check for exact match
if awk '{print $1" "$2}' <<<"$REMOTE_KEYS" | grep -qxF "$LOCAL_KEY_TWOFIELDS"; then
  echo "This SSH key is already uploaded to GitHub. Skipping add."
else
  echo "Uploading SSH key to GitHub..."
  gh ssh-key add "$PUB_KEY" -t "$TITLE"
  echo "SSH key successfully added."
fi

# Test GitHub SSH access
echo "Testing GitHub SSH connection..."
ssh -T git@github.com || true
