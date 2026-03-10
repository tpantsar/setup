#!/bin/bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export SETUP_PATH="${SETUP_PATH:-$(cd "$SETUP_INSTALL/.." && pwd)}"

mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/arch/packages-base.pacman" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"
