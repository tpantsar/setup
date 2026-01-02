#!/bin/bash

# Install onedrive - https://github.com/abraunegg/onedrive/blob/master/docs/install.md
# https://github.com/abraunegg/onedrive/blob/master/docs/advanced-usage.md#configuring-the-client-to-use-multiple-onedrive-accounts--configurations
if ! command -v onedrive &>/dev/null; then
  echo "Installing build dependencies for onedrive ..."
  sudo apt install build-essential
  sudo apt install libcurl4-openssl-dev libsqlite3-dev pkg-config git curl systemd-dev libdbus-1-dev
  sudo apt install libnotify-dev

  if ! ls ~/dlang/ | grep -q '^dmd-'; then
    echo "Installing dmd compiler ..."
    curl -fsS https://dlang.org/install.sh | bash -s dmd

    latest_dmd=$(find ~/dlang -maxdepth 1 -type d -name 'dmd-*' | sed 's:.*/::' | sort -V | tail -n 1)

    # Activate the latest DMD version
    if [[ -n "$latest_dmd" && -f ~/dlang/$latest_dmd/activate ]]; then
      source ~/dlang/$latest_dmd/activate
      echo "Activated DMD version: $latest_dmd"
    else
      echo "No valid DMD version found to activate."
      exit 1
    fi
  else
    echo "dmd compiler is already installed, skipping ..."
  fi

  echo "Removing any existing onedrive source directory ..."
  rm -rf ~/onedrive/

  echo "Cloning and building onedrive from source ..."
  git clone https://github.com/abraunegg/onedrive.git ~/onedrive

  cd ~/onedrive
  ./configure
  make clean
  make
  sudo make install

  # Test onedrive executable
  which onedrive
  onedrive --version

  # Enable onedrive on systemctl
  sudo ps aufxw | grep onedrive
  systemctl --user enable --now onedrive

  echo "Deactivating dmd environment ..."
  deactivate
  echo "onedrive installation completed."
else
  echo "onedrive is already installed"
fi
