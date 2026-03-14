#!/bin/bash

set -eEo pipefail
source /etc/os-release

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="${SETUP_PATH:-$HOME/setup}"

if [[ -d "$SCRIPT_DIR/install" ]]; then
  export SETUP_PATH="${SETUP_PATH:-$SCRIPT_DIR}"
  export SETUP_INSTALL="${SETUP_INSTALL:-$SETUP_PATH/install}"
else
  if ! command -v git >/dev/null 2>&1; then
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

  exec bash "$REPO_PATH/base.sh" "$@"
fi

# dotfiles
bash "$SETUP_INSTALL/install/dotfiles.sh"

case "$ID" in
  arch)
    bash "$SETUP_INSTALL/arch/base.sh"
    ;;
  ubuntu | debian)
    bash "$SETUP_INSTALL/ubuntu/base.sh"
    ;;
  *)
    echo "Unsupported distribution: $ID"
    exit 1
    ;;
esac

echo "Base setup complete."
