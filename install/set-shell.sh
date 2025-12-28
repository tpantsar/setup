#!/bin/bash

# Check if zsh is installed
if ! command -v zsh &>/dev/null; then
  echo "Zsh is not installed."
  exit 1
fi

# Path to zsh
ZSH_PATH="$(command -v zsh)"

# Check if zsh is already the default shell
if [[ "${SHELL:-}" == "$ZSH_PATH" ]]; then
  echo "Zsh is already your default shell."
  exit 0
fi

# Add zsh to /etc/shells if needed
if ! grep -qxF "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

# Change the default shell to zsh
chsh -s "$ZSH_PATH"

echo "Default shell changed to zsh. Please log out and log back in for the change to take effect."
exit 0
