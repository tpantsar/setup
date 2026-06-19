#!/bin/bash

install_package() {
  source /etc/os-release

  case "$ID" in
    arch)
      sudo pacman -Sy --noconfirm --needed "$@"
      ;;
    ubuntu | debian)
      sudo apt-get update
      sudo apt-get install -y "$@"
      ;;
    *)
      echo "Unsupported distribution in install_package: $ID"
      exit 1
      ;;
  esac
}

# Source a script with warning on failure
run_source() {
  local script="$1"
  echo "==> sourcing $script"
  if ! source "$script"; then
    echo "WARN: $script failed; continuing"
  fi
}

# Execute a script with warning on failure
run_exec() {
  local script="$1"
  echo "==> running $script"
  if ! bash "$script"; then
    echo "WARN: $script failed; continuing"
  fi
}

usage() {
  cat <<'EOF'
Usage: install.sh [--mode MODE]

Modes:
  base    Basic server/base installation (default)
  full    Full desktop setup

You can also set MODE=base or MODE=full
EOF
}

# selects base or desktop installation
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

parse_args() {
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
}

ensure_github_cli() {
  if command -v gh >/dev/null 2>&1; then
    echo "GitHub CLI is already installed. Skipping."
    return 0
  fi

  echo "Installing GitHub CLI for SSH key setup..."
  install_package gh
}

# Ensure the setup repository exists and re-exec from it if necessary
ensure_setup_repo() {
  if [[ -d "$SCRIPT_DIR/install" ]]; then
    export SETUP_PATH="${SETUP_PATH:-$SCRIPT_DIR}"
    export SETUP_INSTALL="${SETUP_INSTALL:-$SETUP_PATH/install}"
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    install_package git
  fi

  export SETUP_PATH="$REPO_PATH"
  bash "$SCRIPT_DIR/install/clone-repo.sh"
  exec bash "$REPO_PATH/install.sh" --mode "$MODE" "$@"
}
