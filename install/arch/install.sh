#!/bin/bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_INSTALL="${SETUP_INSTALL:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export SETUP_PATH="${SETUP_PATH:-$(cd "$SETUP_INSTALL/.." && pwd)}"

bash "$SETUP_INSTALL/arch/base.sh"

mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/arch/packages-full.pacman" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"

mapfile -t packages < <(grep -v '^#' "$SETUP_INSTALL/arch/packages.yay" | grep -v '^$')
if command -v yay >/dev/null 2>&1 && [ ${#packages[@]} -gt 0 ]; then
  yay -S --noconfirm --needed "${packages[@]}"
fi
