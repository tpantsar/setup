#!/bin/bash

if ! command -v git &>/dev/null; then
  echo "Git is not installed. Please install Git first."
  return 1
fi

SCRIPT="$HOME/bin/tp-setup-repos"

if [ ! -f "$SCRIPT" ]; then
  echo "Repository setup script not found."
  return 1
fi

# Run as subprocess to isolate errors
# Don't let child script failure stop the master script
bash "$SCRIPT" || true
