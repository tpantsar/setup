#!/bin/bash
# Install VSCode latest version
# https://code.visualstudio.com/docs/setup/linux#_install-vs-code-on-linux

version() {
  echo "vscode path: $(command -v code)"
  echo "vscode version: $(code --version)"
}

if command -v code &>/dev/null; then
  echo "vscode is already installed. Skipping."
  version
  exit 0
fi

sudo apt update
sudo apt install -y wget gpg
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

sudo apt install -y apt-transport-https code

echo "vscode installed successfully!"
version
