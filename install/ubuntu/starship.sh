#!/bin/bash
# starship is a command prompt written in Rust that is fast, customizable, and
# works with any shell. It provides a rich set of features and is highly
# configurable, making it a popular choice for developers who want a powerful
# and visually appealing command prompt.

# https://github.com/starship/starship?tab=readme-ov-file#step-1-install-starship
if ! command -v starship >/dev/null 2>&1; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
else
  echo "starship is already installed"
fi
