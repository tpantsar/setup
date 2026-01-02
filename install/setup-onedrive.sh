#!/bin/bash

CONFIG_DIR="$HOME/.config/onedrive-personal"
SERVICE_NAME="onedrive-personal.service"

if ! command -v onedrive &>/dev/null; then
  echo "OneDrive client not found. Please install it first."
  exit 1
fi

if [ ! -f "$CONFIG_DIR/config" ]; then
  echo "Configuring Personal OneDrive account..."
  mkdir -p "$CONFIG_DIR"
  wget https://raw.githubusercontent.com/abraunegg/onedrive/master/config -O "$CONFIG_DIR/config"

  # Update sync_dir in config file to point to your desired sync location
  sed -i 's|^#\? *sync_dir *=.*|sync_dir = "~/OneDrive-Personal"|' "$CONFIG_DIR/config"
  sed -i 's|^#\? *skip_dir *=.*|skip_dir = ".*Temp.*"|' "$CONFIG_DIR/config"
  echo "OneDrive config file created."

  # Sync the OneDrive account data
  # --sync does a one-time sync
  # --monitor keeps the application running and monitoring for changes both local and remote
  # onedrive --confdir ~/.config/onedrive-personal/ --monitor --verbose

  # Enable service in systemd
  sudo cp /usr/lib/systemd/user/onedrive.service /usr/lib/systemd/user/$SERVICE_NAME
  sudo chmod 644 /usr/lib/systemd/user/$SERVICE_NAME

  # temp file permissions
  sudo chown "$USER":"$USER" /usr/lib/systemd/user/

  # Edit the new systemd file, updating the line beginning with ExecStart so that the confdir mirrors the one you used above:
  # The ~ must be manually expanded when editing systemd file.
  sed -i 's|^ExecStart=.*|ExecStart=/usr/local/bin/onedrive --confdir '"$HOME"'/.config/onedrive-personal --monitor|' /usr/lib/systemd/user/$SERVICE_NAME

  # Enable the new systemd service
  systemctl --user enable $SERVICE_NAME || true
  systemctl --user start $SERVICE_NAME || true
  echo "OneDrive service enabled and started."

  # Check status
  systemctl --user status $SERVICE_NAME --no-pager
  echo "OneDrive Personal account configured successfully."
else
  echo "OneDrive config already exists, skipping."
  exit 0
fi
