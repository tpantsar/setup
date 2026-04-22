#!/usr/bin/env bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/base.sh"

if [[ "$MODE" == "base" ]]; then
  echo "MODE=$MODE. Skipping desktop installation on Arch."
  exit 0
fi

# desktop
mapfile -t packages < <(grep -v '^#' "$SCRIPT_DIR/packages-full.pacman" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"

mapfile -t packages < <(grep -v '^#' "$SCRIPT_DIR/packages.yay" | grep -v '^$')
if command -v yay >/dev/null 2>&1 && [ ${#packages[@]} -gt 0 ]; then
  yay -S --noconfirm --needed "${packages[@]}"
fi
