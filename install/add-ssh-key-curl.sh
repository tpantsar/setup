#!/bin/bash
# Automatically generate an SSH key (if missing) and add it to GitHub via API.

set -euo pipefail

KEY_PATH="${HOME}/.ssh/id_ed25519"
EMAIL="${EMAIL:-$(git config user.email || echo "user@example.com")}"
TITLE="${TITLE:-$(hostname)-$(date +%Y%m%d-%H%M%S)}"

# --- Check for GitHub token ---
if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Please set GITHUB_TOKEN as an environment variable with 'admin:public_key' scope."
  echo "Example: export GITHUB_TOKEN=ghp_yourtokenhere"
  exit 1
fi

# --- Generate SSH key if missing ---
if [[ ! -f "${KEY_PATH}" ]]; then
  echo "Generating a new SSH key at ${KEY_PATH}..."
  mkdir -p ~/.ssh
  ssh-keygen -t ed25519 -C "${EMAIL}" -f "${KEY_PATH}" -N ""
else
  echo "SSH key already exists at ${KEY_PATH}"
fi

PUB_KEY=$(cat "${KEY_PATH}.pub")

# --- Upload key to GitHub ---
echo "Uploading SSH key to GitHub..."

RESPONSE=$(curl -s -w "%{http_code}" -o /tmp/github_response.json \
  -X POST \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/user/keys \
  -d "{\"title\":\"${TITLE}\",\"key\":\"${PUB_KEY}\"}")

HTTP_CODE=$(tail -n1 <<<"${RESPONSE}")

if [[ "${HTTP_CODE}" == "201" ]]; then
  echo "SSH key successfully added to GitHub."
  cat /tmp/github_response.json | jq -r '.url'
else
  echo "Failed to add SSH key (HTTP ${HTTP_CODE}). Response:"
  cat /tmp/github_response.json
  exit 1
fi

# --- Test GitHub SSH access ---
echo "Testing GitHub SSH access..."
ssh -T git@github.com || true
