#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Desktop
PERIPHERALS="$SCRIPT_DIR/desktop/peripherals.dconf"
INPUT_SOURCES="$SCRIPT_DIR/desktop/input-sources.dconf"

# Shell
EXTENSIONS="$SCRIPT_DIR/shell/extensions.dconf"

echo "Dumping GNOME settings..."

dconf dump /org/gnome/shell/extensions/ > $EXTENSIONS
dconf dump /org/gnome/desktop/peripherals/ > "$PERIPHERALS"
dconf dump /org/gnome/desktop/input-sources/ > "$INPUT_SOURCES"

echo "Dumped GNOME settings to:"
echo "  $EXTENSIONS"
echo "  $PERIPHERALS"
echo "  $INPUT_SOURCES"
