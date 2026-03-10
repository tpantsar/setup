#!/bin/bash
# Install Go language
# https://go.dev/doc/install

if command -v go &>/dev/null; then
  echo "go is already installed. Skipping."
  exit 0
fi

sudo rm -rf /usr/local/go
TARBALL="/tmp/go1.25.5.linux-amd64.tar.gz"
curl -Lo ${TARBALL} "https://go.dev/dl/go1.25.5.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "$TARBALL"
sudo rm -f "$TARBALL"

export PATH=$PATH:/usr/local/go/bin
go version
