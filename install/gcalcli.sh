#!/bin/bash

if [ -d "$HOME/gcalcli" ]; then
  echo "gcalcli already installed, updating the repository..."
  cd "$HOME/gcalcli"
  git pull --rebase --autostash origin main
  echo "gcalcli repository updated"
  exit 0
else
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/gcalcli/main/install.sh)" "" --unattended
  echo "gcalcli installed."
fi
