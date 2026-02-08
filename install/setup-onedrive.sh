#!/bin/bash
# Set up the OneDrive client for a personal account on a Linux system using systemd for automatic syncing.
# It checks for the OneDrive client, creates a config file, sets up a systemd service, and starts the service to keep OneDrive in sync.

if ! command -v onedrive &>/dev/null; then
  echo "OneDrive client not found. Please install it first."
  exit 1
fi

CONFIG_URL="https://raw.githubusercontent.com/abraunegg/onedrive/master/config"
CONFIG_DIR="$HOME/.config/onedrive-personal"
CONFIG_FILE="$CONFIG_DIR/config"

SYNC_DIR="~/OneDrive-Personal"
SKIP_DIR=".*Temp.*"

SERVICE_NAME="onedrive-personal.service"
SERVICE_PATH="/usr/lib/systemd/user/$SERVICE_NAME"

ONEDRIVE_PATH=$(which onedrive)
echo "Detected OneDrive client at: $ONEDRIVE_PATH"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuring OneDrive account for ${CONFIG_DIR} ..."
  mkdir -p "$CONFIG_DIR"
  echo "Created config directory: $CONFIG_DIR"
  echo "Downloading default OneDrive config file from GitHub URL: $CONFIG_URL to $CONFIG_FILE"
  wget "$CONFIG_URL" -O "$CONFIG_FILE"

  # Update sync_dir in config file to point to your desired sync location
  sed -i 's|^#\? *sync_dir *=.*|sync_dir = "'"$SYNC_DIR"'"|' "$CONFIG_FILE"
  sed -i 's|^#\? *skip_dir *=.*|skip_dir = "'"$SKIP_DIR"'"|' "$CONFIG_FILE"
  echo "OneDrive config file created."

  # Sync the OneDrive account data
  # --sync does a one-time sync
  # --monitor keeps the application running and monitoring for changes both local and remote
  echo "Performing initial OneDrive sync on ${CONFIG_DIR} ..."
  echo "This may require you to authenticate via a web browser."
  onedrive --confdir "$CONFIG_DIR" --sync --verbose

  # Enable service in systemd
  sudo cp /usr/lib/systemd/user/onedrive.service $SERVICE_PATH
  sudo chmod 644 $SERVICE_PATH

  # temp file permissions
  sudo chown "$USER":"$USER" /usr/lib/systemd/user/

  # Edit the new systemd file, updating the line beginning with ExecStart so that the confdir mirrors the one you used above:
  # The ~ must be manually expanded when editing systemd file.
  sed -i 's|^ExecStart=.*|ExecStart='$ONEDRIVE_PATH' --confdir '"$CONFIG_DIR"' --monitor --verbose|' $SERVICE_PATH
  echo "Systemd service file created and updated with correct config directory."

  # Start systemd service and check status
  systemctl --user enable $SERVICE_NAME || true
  systemctl --user start $SERVICE_NAME || true
  echo "OneDrive service $SERVICE_NAME enabled and started."

  systemctl --user status $SERVICE_NAME --no-pager
  echo "OneDrive account configured successfully with $CONFIG_FILE and $SERVICE_PATH."
  echo "Please review the config and service files below to ensure they are correct:"

  echo "OneDrive config file $CONFIG_FILE"
  echo
  /usr/bin/cat $CONFIG_FILE

  echo "systemd service file $SERVICE_PATH"
  echo
  /usr/bin/cat $SERVICE_PATH
else
  echo "OneDrive config already exists, skipping."
  exit 0
fi

# Create symlink for OneDrive executable
# Arch AUR installation may place it in /usr/bin/onedrive, but some installations may place it elsewhere
if [ -f "/usr/bin/onedrive" ] && [ ! -f "$ONEDRIVE_PATH" ]; then
  sudo ln -s /usr/bin/onedrive $ONEDRIVE_PATH
  echo "Symlink created for onedrive: $ONEDRIVE_PATH -> /usr/bin/onedrive"
else
  echo "OneDrive executable not found at /usr/bin/onedrive or symlink already exists, skipping ..."
  echo "Please ensure onedrive is installed and available in your PATH."
  echo "You can check the location of onedrive with: which onedrive"
  echo
  ls -l "$(command -v onedrive)"
fi
