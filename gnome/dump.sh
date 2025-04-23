#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Extensions
echo "Dumping GNOME extensions settings..."
dconf dump /org/gnome/shell/extensions/ > "$SCRIPT_DIR/gnome-extensions.dconf"

# Peripherals
echo "Dumping GNOME peripherals settings..."
dconf dump /org/gnome/desktop/peripherals/ > "$SCRIPT_DIR/gnome-peripherals.dconf"

echo "Dumped GNOME settings to $SCRIPT_DIR/gnome-extensions.dconf and $SCRIPT_DIR/gnome-peripherals.dconf."