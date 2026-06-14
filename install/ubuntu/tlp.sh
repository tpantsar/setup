#!/bin/bash
# TLP is designed to apply laptop battery-saving settings automatically, and its defaults are already optimized for battery use
# https://linrunner.de/tlp/index.html?utm_source=chatgpt.com

if ! command -v tlp >/dev/null 2>&1; then
  echo "Installing tlp..."
  sudo apt install -y tlp
else
  echo "tlp is already installed"
fi

sudo systemctl disable --now power-profiles-daemon.service
sudo systemctl enable --now tlp.service

# Inspect what TLP is actually doing
# sudo tlp-stat -s
# sudo tlp-stat -b
# sudo tlp-stat -p
