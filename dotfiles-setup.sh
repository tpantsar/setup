#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/tpantsar/dotfiles"
REPO_NAME="dotfiles"

# Check if stow is installed using dpkg (Debian/Ubuntu)
is_stow_installed() {
	dpkg -s "stow" &>/dev/null
}

if ! is_stow_installed; then
	echo "GNU Stow is not installed. Installing..."
	sudo apt update && sudo apt install -y stow
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
	echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
	git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
	cd "$REPO_NAME"
	stow .
else
	echo "Failed to clone the repository."
	exit 1
fi
