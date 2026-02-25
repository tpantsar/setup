#!/bin/bash

# The common fix on Debian/Ubuntu and derivatives: set x-www-browser
sudo update-alternatives --config x-www-browser
sudo update-alternatives --config www-browser
sudo update-alternatives --config gnome-www-browser

echo "Checking config permissions..."
ls -ld ~ ~/.config ~/.local ~/.local/share ~/.local/share/applications
