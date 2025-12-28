#!/bin/bash
# Clones or updates the setup repository

REPO_URL="https://github.com/tpantsar/setup.git"
REPO_PATH="$HOME/setup"

mkdir -p "$REPO_PATH" 2>/dev/null || true

if [[ -d "$REPO_PATH/.git" ]]; then
  echo "Updating $REPO_PATH..."
  if ! git -C "$REPO_PATH" pull --ff-only; then
    echo "Warning: git pull --ff-only failed (local changes or non-FF). Continuing without updating."
  fi
else
  # If the folder exists but isn't a git repo, don't try to clone into it.
  if [[ -e "$REPO_PATH" && ! -z "$(ls -A "$REPO_PATH" 2>/dev/null)" ]]; then
    echo "Warning: $REPO_PATH exists but is not a git repo. Skipping clone."
  else
    echo "Cloning into $REPO_PATH..."
    if ! git clone "$REPO_URL" "$REPO_PATH"; then
      echo "Warning: git clone failed. Continuing."
    fi
  fi
fi
