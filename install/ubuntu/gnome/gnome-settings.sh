#!/bin/bash

echo "Configuring Gnome settings..."

WALLPAPER="${SETUP_INSTALL}/ubuntu/gnome/wallpaper.jpeg"
echo "setting wallpaper to ${WALLPAPER}"
gsettings set org.gnome.desktop.background picture-uri "file://${WALLPAPER}"
gsettings set org.gnome.desktop.background picture-uri-dark "file://${WALLPAPER}"
gsettings set org.gnome.desktop.background picture-options 'zoom'

# Theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

# Input sources
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape', 'grp:win_space_toggle', 'terminate:ctrl_alt_bksp']"
