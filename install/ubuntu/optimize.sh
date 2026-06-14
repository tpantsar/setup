#!/bin/bash

# Disable Snapd entirely (removes 12+ background services)
sudo systemctl disable --now snapd.socket snapd.seeded.service snapd.service
sudo apt purge -y snapd gnome-software-plugin-snap

sudo apt autoremove --purge
rm -rf ~/snap

# Disable unnecessary GNOME services
gsettings set org.gnome.desktop.session idle-delay 0 # Prevents auto-lock distraction
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
sudo systemctl disable --now gnome-remote-desktop.service

# Enable ZRAM swap (reduces SSD wear, improves memory pressure response)
sudo apt install -y zram-config
sudo systemctl restart zram-config

sudo systemctl disable --now bluetooth.service                        #  disable if you never use Bluetooth
sudo systemctl disable --now cups.service cups-browsed.service        #  disable if you never print
sudo systemctl disable --now avahi-daemon.service avahi-daemon.socket #  disable if you do not use local network discovery
sudo systemctl disable --now ModemManager.service                     #  disable if you do not use LTE/WWAN modems
sudo systemctl disable --now packagekit.service                       #  often unnecessary for CLI apt-only workflow
# sudo systemctl disable --now fwupd.service                            #  keep if you want firmware update checks
