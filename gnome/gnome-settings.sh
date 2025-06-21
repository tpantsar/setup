#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
echo "setting wallpaper to ${SCRIPT_DIR}/wallpaper.jpeg"
gsettings set org.gnome.desktop.background picture-uri-dark "file://${SCRIPT_DIR}/wallpaper.jpeg"
gsettings set org.gnome.desktop.background picture-options 'zoom'

# Input sources
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape', 'grp:win_space_toggle', 'terminate:ctrl_alt_bksp']"
