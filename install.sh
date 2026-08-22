#!/usr/bin/env bash

set -eEo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="${SETUP_PATH:-$HOME/setup}"

source "$SCRIPT_DIR/install/utils.sh"
parse_args "$@"
set -- "${POSITIONAL_ARGS[@]}"
ensure_setup_repo "$@"

echo "Starting Base setup..."
sudo timedatectl set-timezone Europe/Helsinki

run_exec "$SETUP_INSTALL/bypass-sudo.sh"
run_exec "$SETUP_INSTALL/setup-permissions.sh"
run_exec "$SETUP_INSTALL/ssh-keygen.sh"

ensure_github_cli

run_exec "$SETUP_INSTALL/ssh-gh.sh"
run_exec "$SETUP_INSTALL/dotfiles.sh"
run_exec "$SETUP_INSTALL/tailscale.sh"

run_exec "$SETUP_INSTALL/delta.sh"
run_exec "$SETUP_INSTALL/lazygit.sh"
run_exec "$SETUP_INSTALL/lazydocker.sh"

echo "Base setup completed."

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
