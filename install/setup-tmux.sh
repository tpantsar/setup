#!/bin/bash

if ! command -v tmux &>/dev/null; then
  echo "Tmux is not installed. Please install it first."
  return 1
fi

SCRIPT="$HOME/bin/tp-setup-tmux"

if [ ! -f "$SCRIPT" ]; then
  echo "Tmux setup script not found."
  return 1
fi

# Run as subprocess to isolate errors
bash "$SCRIPT" || true
