#!/bin/bash

LOG_FILE="/var/log/server_setup_$(date +%Y%m%d_%H%M%S).log"

REAL_USER="${SUDO_USER:-$USER}"
REAL_GROUP="$(id -gn "$REAL_USER")"

sudo touch "$LOG_FILE"
sudo chown "$REAL_USER:$REAL_GROUP" "$LOG_FILE"

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

# require_root

# https://oneuptime.com/blog/post/2026-03-02-how-to-automate-server-setup-scripts-on-ubuntu/view
# ~/.local/share/omarchy/install/first-run/firewall.sh
log "Configuring UFW firewall..."

# Allow nothing in, everything out
sudo ufw default deny incoming >>"$LOG_FILE" 2>&1
sudo ufw default allow outgoing >>"$LOG_FILE" 2>&1

# Allow SSH
sudo ufw allow 22/tcp >>"$LOG_FILE" 2>&1

# Allow ports for LocalSend
sudo ufw allow 53317/udp >>"$LOG_FILE" 2>&1
sudo ufw allow 53317/tcp >>"$LOG_FILE" 2>&1

# Allow Docker containers to use DNS on host
sudo ufw allow in proto udp from 172.16.0.0/12 to 172.17.0.1 port 53 comment 'allow-docker-dns' >>"$LOG_FILE" 2>&1
sudo ufw allow in proto udp from 192.168.0.0/16 to 172.17.0.1 port 53 comment 'allow-docker-dns' >>"$LOG_FILE" 2>&1

# Allow additional ports
sudo ufw allow 80/tcp >>"$LOG_FILE" 2>&1
log "Opened port: 80/tcp"

sudo ufw allow 443/tcp >>"$LOG_FILE" 2>&1
log "Opened port: 443/tcp"

# Enable firewall without interactive prompt
sudo ufw --force enable >>"$LOG_FILE" 2>&1
log "Firewall enabled"

# Enable UFW systemd service to start on boot
sudo systemctl enable ufw

# Turn on Docker protections
sudo ufw-docker install
sudo ufw reload

log "Firewall status:"
sudo ufw status verbose | tee -a "$LOG_FILE"
