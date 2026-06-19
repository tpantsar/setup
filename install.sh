#!/usr/bin/env bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="${SETUP_PATH:-$HOME/setup}"

source "$SCRIPT_DIR/install/utils.sh"

parse_args "$@"
set -- "${POSITIONAL_ARGS[@]}"
ensure_setup_repo "$@"

source "$SETUP_INSTALL/steps/base.sh"

if [[ "$MODE" == "install" ]]; then
  source "$SETUP_INSTALL/steps/desktop.sh"
fi

source /etc/os-release
case "$ID" in
  arch)
    echo "Arch Linux detected ($MODE mode)"
    MODE=$MODE bash "$SETUP_INSTALL/arch/install.sh"
    ;;
  ubuntu | debian)
    echo "Ubuntu/Debian detected ($MODE mode)"
    MODE=$MODE bash "$SETUP_INSTALL/ubuntu/install.sh"
    ;;
  *)
    echo "Unsupported distribution: $ID"
    exit 1
    ;;
esac

echo "install.sh completed. You may want to reboot your system with:"
echo "sudo reboot"
