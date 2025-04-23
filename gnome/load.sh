#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Extensions
echo "Loading GNOME extensions settings..."
dconf load /org/gnome/shell/extensions/ < "$SCRIPT_DIR/gnome-extensions.dconf"

# Peripherals
echo "Loading GNOME peripherals settings..."
dconf load /org/gnome/desktop/peripherals/ < "$SCRIPT_DIR/gnome-peripherals.dconf"

echo "Loaded GNOME settings to $SCRIPT_DIR/gnome-extensions.dconf and $SCRIPT_DIR/gnome-peripherals.dconf."
