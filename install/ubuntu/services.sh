#!/bin/bash

SERVICES=(
  gdm.service
  NetworkManager.service
)

echo "Configuring systemd services..."
for service in "${SERVICES[@]}"; do
  if ! systemctl is-enabled "$service" &>/dev/null; then
    echo "Enabling $service..."
    sudo systemctl enable "$service"
  else
    echo "$service is already enabled"
  fi
  sudo systemctl start "$service"
done
