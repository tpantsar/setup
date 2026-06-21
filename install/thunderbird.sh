#!/usr/bin/env bash
# Install as deb package: https://askubuntu.com/questions/1513445/how-to-install-thunderbird-as-a-traditional-deb-package-without-snap-in-ubuntu-2
# Mozilla install guide: https://support.mozilla.org/en-US/kb/installing-thunderbird-linux#w_installation-location

set -euo pipefail

if command -v thunderbird >/dev/null 2>&1; then
  echo "thunderbird is already installed."
  echo "thunderbird path: $(command -v thunderbird)"
  echo "thunderbird version: $(thunderbird --version)"
  exit 0
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cd "$TMP_DIR"

curl -L -o thunderbird.tar.xz "https://download.mozilla.org/?product=thunderbird-latest-SSL&os=linux64&lang=en-US"

tar -xf thunderbird.tar.xz

sudo rm -rf /opt/thunderbird
sudo mv thunderbird /opt/thunderbird

# Create symlink to thunderbird executable
sudo ln -sf /opt/thunderbird/thunderbird /usr/local/bin/thunderbird

echo "thunderbird path: $(command -v thunderbird)"
echo "thunderbird version: $(thunderbird --version)"

# Download a copy of the desktop file
sudo install -d /usr/local/share/applications
sudo wget -O /usr/local/share/applications/thunderbird.desktop https://raw.githubusercontent.com/mozilla/sumo-kb/main/installing-thunderbird-linux/thunderbird.desktop

sudo sed -i 's|^Exec=.*|Exec=/opt/thunderbird/thunderbird %u|' /usr/local/share/applications/thunderbird.desktop

# Remove the snap version if found
if command -v snap >/dev/null 2>&1 && snap list thunderbird >/dev/null 2>&1; then
  sudo snap remove thunderbird
fi

# Ensure that unattended upgrades do not reinstall the snap version of Thunderbird
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-thunderbird >/dev/null
