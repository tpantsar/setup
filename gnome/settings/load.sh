#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Desktop
PERIPHERALS="$SCRIPT_DIR/desktop/peripherals.dconf"
INPUT_SOURCES="$SCRIPT_DIR/desktop/input-sources.dconf"

# Shell
EXTENSIONS="$SCRIPT_DIR/shell/extensions.dconf"

echo "Loading GNOME settings..."

dconf load /org/gnome/shell/extensions/ < $EXTENSIONS
dconf load /org/gnome/desktop/peripherals/ < "$PERIPHERALS"
dconf load /org/gnome/desktop/input-sources/ < "$INPUT_SOURCES"

echo "Loaded GNOME settings from:"
echo "  $EXTENSIONS"
echo "  $PERIPHERALS"
echo "  $INPUT_SOURCES"
