#!/bin/bash

set -eEo pipefail

usage() {
  cat <<'EOF'
Usage: install.sh [--mode MODE]

Modes:
  base    Basic server/base installation (default)
  full    Full desktop setup

You can also set MODE=base or MODE=full
EOF
}

# selects base.sh or install.sh
normalize_mode() {
  case "${1,,}" in
    base | basic | server)
      echo "base"
      ;;
    full | desktop)
      echo "install"
      ;;
    *)
      echo "Invalid mode: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
}

MODE="${MODE:-base}"
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      [[ $# -ge 2 ]] || {
        echo "--mode requires a value" >&2
        usage >&2
        exit 1
      }
      MODE="$2"
      shift 2
      ;;
    --mode=*)
      MODE="${1#*=}"
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

MODE="$(normalize_mode "$MODE")"
set -- "${POSITIONAL_ARGS[@]}"

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

  exec bash "$REPO_PATH/install.sh" --mode "$MODE" "$@"
fi

bash "$SETUP_INSTALL/dotfiles.sh"
bash "$SETUP_INSTALL/tailscale.sh"

source /etc/os-release
case "$ID" in
  arch)
    echo "Arch Linux detected ($MODE mode)"
    bash "$SETUP_INSTALL/arch/$MODE.sh"
    ;;
  ubuntu | debian)
    echo "Ubuntu/Debian detected ($MODE mode)"
    bash "$SETUP_INSTALL/ubuntu/$MODE.sh"
    ;;
  *)
    echo "Unsupported distribution: $ID"
    exit 1
    ;;
esac

if [[ "$MODE" == "base" ]]; then
  echo "Base setup complete."
else
  echo "Setup complete! You may want to reboot your system with:"
  echo "sudo reboot"
fi
