#!/bin/bash
# Install VSCode latest version
# https://code.visualstudio.com/docs/setup/linux#_install-vs-code-on-linux

if command -v code &>/dev/null; then
  echo "VSCode is already installed. Skipping."
  exit 0
fi

sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

sudo tee /etc/apt/sources.list.d/vscode.sources >/dev/null <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

sudo apt install apt-transport-https
sudo apt update
sudo apt install code

code --version
