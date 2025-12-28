#!/bin/bash
# Install luarocks

PREFIX="/usr/local"
LUA_INCLUDE_DIR="$PREFIX/include"

# --- prerequisites check ---
command -v curl >/dev/null 2>&1 || {
  echo "curl not found, install it first."
  exit 1
}
command -v tar >/dev/null 2>&1 || {
  echo "tar not found, install it first."
  exit 1
}
command -v make >/dev/null 2>&1 || {
  echo "make not found, install it first."
  exit 1
}

# --- fetch latest release version ---
LUAROCKS_VERSION=$(curl -s https://api.github.com/repos/luarocks/luarocks/releases/latest | \grep -Po '"tag_name": *"v\K[^"]*')

if [ -z "$LUAROCKS_VERSION" ]; then
  echo "Failed to fetch latest LuaRocks release version."
  exit 1
fi

# download & extract
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

TARBALL="luarocks.tar.gz"
curl -Lo ${TARBALL} "https://github.com/luarocks/luarocks/releases/download/v${LUAROCKS_VERSION}/luarocks-${LUAROCKS_VERSION}.tar.gz"
tar -xzf "$TARBALL"

# go into extracted directory
cd luarocks-*

# build & install
./configure --with-lua-include="$LUA_INCLUDE_DIR"
make
sudo make install

# cleanup
cd /
rm -rf "$TMP_DIR"

echo "LuaRocks installed successfully."
luarocks --version
