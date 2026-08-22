#!/usr/bin/env bash

set -euo pipefail

repo_dir="${HOME:?}/src/neovim"
install_prefix="${HOME:?}/.local"
target_branch="release-0.12"
target_version=0.12.0
build=Release

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_deps() {
  if have_cmd apt-get; then
    echo "Debian/Ubuntu detected. Installing dependencies via apt-get"
    sudo apt-get update
    sudo apt-get install -y ninja-build gettext cmake curl build-essential git
  elif have_cmd pacman; then
    echo "Arch detected. Installing dependencies via pacman"
    sudo pacman -S --noconfirm --needed base-devel cmake ninja curl git
  else
    echo "Unsupported package manager. Install dependencies manually." >&2
    exit 1
  fi
}

check_toolchain() {
  echo "Checking curl/cmake health..."
  curl --version >/dev/null
  cmake --version >/dev/null
  git --version >/dev/null
}

current_nvim_version() {
  if have_cmd nvim; then
    nvim --version | awk 'NR==1 { sub(/^v/, "", $2); print $2 }'
  else
    echo ""
  fi
}

version_ge() {
  # returns 0 if $1 >= $2
  [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | tail -n1)" = "$1" ]
}

need_install=false
installed_version="$(current_nvim_version)"

if [ -z "$installed_version" ]; then
  echo "Neovim is not installed"
  need_install=true
elif version_ge "$installed_version" "$target_version"; then
  echo "Neovim $installed_version is already >= $target_version"
else
  echo "Neovim $installed_version is older than $target_version"
  need_install=true
fi

if [ "$need_install" = true ]; then
  install_deps
  check_toolchain

  mkdir -p "$(dirname "$repo_dir")"

  if [ ! -d "$repo_dir/.git" ]; then
    git clone --branch "$target_branch" --single-branch https://github.com/neovim/neovim "$repo_dir"
  fi

  cd "$repo_dir"
  git fetch origin
  git checkout "$target_branch"
  git reset --hard "origin/$target_branch"

  # Recommended when reusing a repo or changing CMake settings
  make distclean

  echo "Building Neovim from $target_branch with CMAKE_BUILD_TYPE=$build and CMAKE_INSTALL_PREFIX=$install_prefix"
  make CMAKE_BUILD_TYPE="$build" CMAKE_INSTALL_PREFIX="$install_prefix"

  ./build/bin/nvim --version | grep '^Build'

  make install

  echo "Installed to: $install_prefix/bin/nvim"
  "$install_prefix/bin/nvim" --version
  echo "Ensure $install_prefix/bin is in PATH"
else
  echo "Nothing to do"
fi
