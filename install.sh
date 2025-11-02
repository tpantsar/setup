#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define paths
export SETUP_PATH="$HOME/.local/share/setup"
export SETUP_INSTALL="$SETUP_PATH/install"
export SETUP_INSTALL_LOG_FILE="/var/log/setup-install.log"
export PATH="$SETUP_PATH/bin:$PATH"

# Install
source "$SETUP_INSTALL/helpers/all.sh"
source "$SETUP_INSTALL/preflight/all.sh"
source "$SETUP_INSTALL/packaging/all.sh"
source "$SETUP_INSTALL/post-install/all.sh"
