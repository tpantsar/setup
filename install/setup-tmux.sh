#!/bin/bash

if ! command -v tmux &>/dev/null; then
  echo "Tmux is not installed. Please install it first."
  exit 1
fi

SCRIPT="$HOME/bin/tp-setup-tmux"

if [ ! -f "$SCRIPT" ]; then
  echo "Tmux setup script not found."
  exit 1
fi

# Run as subprocess to isolate errors
bash "$SCRIPT"
