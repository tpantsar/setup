#!/bin/bash

LOG_FILE="/var/log/server_setup_$(date +%Y%m%d_%H%M%S).log"

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

# https://oneuptime.com/blog/post/2026-03-02-how-to-automate-server-setup-scripts-on-ubuntu/view
configure_firewall() {
  log "Configuring UFW firewall..."

  # Reset creates a repeatable baseline, but removes existing UFW rules
  # ufw --force reset >>"$LOG_FILE" 2>&1
  ufw default deny incoming >>"$LOG_FILE" 2>&1
  ufw default allow outgoing >>"$LOG_FILE" 2>&1

  # Allow SSH
  ufw allow 22/tcp >>"$LOG_FILE" 2>&1

  # Allow additional ports passed as arguments
  for port in "$@"; do
    ufw allow "$port" >>"$LOG_FILE" 2>&1
    log "Opened port: $port"
  done

  # Enable without interactive prompt
  ufw --force enable >>"$LOG_FILE" 2>&1
  log "Firewall enabled"
  ufw status verbose | tee -a "$LOG_FILE"
}

require_root

log "--- Configuring firewall ---"
configure_firewall 80/tcp 443/tcp
