#!/bin/bash

if ! command -v git &>/dev/null; then
  echo "Git is not installed. Please install Git first."
  exit 1
fi

SCRIPT="$HOME/bin/repos"

if [ ! -f "$SCRIPT" ]; then
  echo "Repository setup script not found: $SCRIPT"
  exit 1
fi

# Run as subprocess to isolate errors
# Don't let child script failure stop the master script
bash "$SCRIPT"
