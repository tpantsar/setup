#!/bin/bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="${SETUP_PATH:-$HOME/setup}"

if [[ -d "$SCRIPT_DIR/install" ]]; then
  export SETUP_PATH="${SETUP_PATH:-$SCRIPT_DIR}"
  export SETUP_INSTALL="${SETUP_INSTALL:-$SETUP_PATH/install}"
else
  if ! command -v git >/dev/null 2>&1; then
    source /etc/os-release
    case "$ID" in
      arch)
        sudo pacman -Sy --noconfirm git
        ;;
      ubuntu | debian)
        sudo apt-get update
        sudo apt-get install -y git
        ;;
      *)
        echo "Unsupported distribution: $ID"
        exit 1
        ;;
    esac
  fi

  export SETUP_PATH="$REPO_PATH"
  bash "$SCRIPT_DIR/install/clone-repo.sh"

  exec bash "$REPO_PATH/install.sh" "$@"
fi

source /etc/os-release

case "$ID" in
  arch)
    echo "Arch Linux detected"
    bash "$SETUP_INSTALL/arch/install.sh"
    ;;
  ubuntu | debian)
    echo "Ubuntu/Debian detected"
    bash "$SETUP_INSTALL/ubuntu/install.sh"
    ;;
  *)
    echo "Unsupported distribution: $ID"
    exit 1
    ;;
esac

echo "Setup complete! You may want to reboot your system with:"
echo "sudo reboot"
