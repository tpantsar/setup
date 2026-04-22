#!/bin/bash

# uv (Python package manager) - https://docs.astral.sh/uv/
if ! command -v uv &>/dev/null; then
  echo "Installing uv ..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  echo "uv is already installed"
fi
