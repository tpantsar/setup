#!/usr/bin/env bash
# Install or update tmux from source.

source /etc/os-release

repo="https://github.com/tmux/tmux.git"
install_dir="$HOME/tmux-installation"

if [[ "$ID" == "arch" ]]; then
  yay -S --noconfirm --needed tmux
  exit 0
fi

if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
  echo "Unsupported distribution: $ID"
  exit 1
fi

# Find the latest stable version, excluding prereleases such as 3.6-rc1.
latest_version="$(
  git ls-remote --tags --refs "$repo" |
    sed 's|.*/||' |
    /usr/bin/grep -E '^[0-9]+(\.[0-9]+)+[a-z]?$' |
    sort -V |
    tail -n 1
)"

if [[ -z "$latest_version" ]]; then
  echo "Could not determine the latest tmux version."
  exit 1
fi

installed_version=""
if command -v tmux >/dev/null 2>&1; then
  installed_version="$(tmux -V | awk '{print $2}')"
fi

if [[ "$installed_version" == "$latest_version" ]]; then
  echo "tmux $installed_version is already up to date."
  exit 0
fi

if [[ "$installed_version" == next-* ]]; then
  echo "Replacing development build $installed_version with stable $latest_version..."
elif [[ -n "$installed_version" ]]; then
  echo "Updating tmux from $installed_version to $latest_version..."
else
  echo "Installing tmux $latest_version..."
fi

sudo apt-get update
sudo apt-get install -y \
  autoconf \
  automake \
  bison \
  build-essential \
  libevent-dev \
  ncurses-dev \
  pkg-config

if [[ -d "$install_dir/.git" ]]; then
  git -C "$install_dir" fetch --tags --prune
else
  git clone "$repo" "$install_dir"
fi

cd "$install_dir"
git -C "$install_dir" checkout --force "$latest_version"

./autogen.sh
./configure --enable-static
make -j"$(nproc)"
sudo make install

hash -r

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux installation failed."
  exit 1
fi

echo "tmux installed successfully."
echo "tmux path: $(command -v tmux)"
echo "tmux version: $(tmux -V)"
