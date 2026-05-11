#!/usr/bin/env bash
# Atuin replaces your existing shell history with a SQLite database, and
# records additional context for your commands. With this context, Atuin gives
# you faster and better search of your shell history.
# https://docs.atuin.sh/cli/

if command -v atuin >/dev/null 2>&1; then
  echo "atuin is already installed."
  echo "$(atuin --version)"
  exit 1
fi

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# atuin register -u <USERNAME> -e <EMAIL>
# atuin import auto
# atuin sync
