#!/usr/bin/env bash
# Watch a file or folder and automatically commit changes to a git repo easily.
# https://github.com/gitwatch/gitwatch

set -euo pipefail

dir="$HOME/gitwatch"

if ! command -v git >/dev/null 2>&1 || ! command -v inotifywait >/dev/null 2>&1; then
  source /etc/os-release

  case "$ID" in
    arch)
      sudo pacman -S --needed --noconfirm git inotify-tools
      ;;

    debian | ubuntu)
      sudo apt update
      sudo apt install -y git inotify-tools
      ;;

    *)
      echo "Unsupported distribution: $ID" >&2
      exit 1
      ;;
  esac
fi

if [[ -d "$dir" ]]; then
  echo "gitwatch is already cloned to $dir. Updating the repository."
  cd $dir
  git pull --rebase --autostash
else
  git clone https://github.com/gitwatch/gitwatch.git $dir
  cd $dir
fi

echo "Installing gitwatch.sh to /usr/local/bin/gitwatch"
sudo install -b gitwatch.sh /usr/local/bin/gitwatch

echo "gitwatch installed successfully!"
echo "gitwatch path: $(command -v gitwatch)"
