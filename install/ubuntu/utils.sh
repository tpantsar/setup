#!/bin/bash

# Function to check if a package is installed (Debian/Ubuntu)
is_installed() {
  dpkg -s "$1" &>/dev/null
}

# Function to install packages if not already installed
install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing: ${to_install[*]}"
    sudo apt update
    sudo apt install -y "${to_install[@]}"
  else
    echo "All packages already installed."
  fi
}

packages_from_file() {
  local package_file="$1"
  grep -v '^#' "$package_file" | grep -v '^$'
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
  local message="$1"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${GREEN}[${timestamp}] ${message}${NC}" | tee -a "$LOG_FILE"
}

warn() {
  local message="$1"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${YELLOW}[${timestamp}] WARNING: ${message}${NC}" | tee -a "$LOG_FILE"
}

error() {
  local message="$1"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${RED}[${timestamp}] ERROR: ${message}${NC}" | tee -a "$LOG_FILE"
}

# Root check
require_root() {
  if [ "$(id -u)" -ne 0 ]; then
    error "This script must be run as root"
    exit 1
  fi
}
