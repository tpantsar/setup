#!/bin/bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export SETUP_PATH="${SETUP_PATH:-$(cd "$SETUP_INSTALL/.." && pwd)}"

source "$SETUP_INSTALL/utils.sh"
source "$SETUP_INSTALL/ubuntu/utils.sh"

bash "$SETUP_PATH/base.sh"

mapfile -t packages < <(packages_from_file "$SETUP_INSTALL/ubuntu/packages-full.apt")
install_packages "${packages[@]}"

# Ensure ~/.local/bin exists for user-installed binaries
mkdir -p "$HOME/.local/bin"

run_exec "$SETUP_INSTALL/fzf.sh"
run_exec "$SETUP_INSTALL/neovim.sh"
run_exec "$SETUP_INSTALL/setup-python.sh"
run_exec "$SETUP_INSTALL/ubuntu/custom.sh"
run_exec "$SETUP_INSTALL/ubuntu/git.sh"
run_exec "$SETUP_INSTALL/ubuntu/docker.sh"
run_exec "$SETUP_INSTALL/ubuntu/yazi.sh"
run_exec "$SETUP_INSTALL/ubuntu/go.sh"
