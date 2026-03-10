#!/bin/bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SETUP_PATH="${SETUP_PATH:-$SCRIPT_DIR}"
export SETUP_INSTALL="${SETUP_INSTALL:-$SETUP_PATH/install}"

bash "$SETUP_INSTALL/clone-repo.sh"

source /etc/os-release

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

echo "Setup complete! You may want to reboot your system with:"
echo "sudo reboot"
