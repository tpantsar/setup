#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Shell
EXTENSIONS="$SCRIPT_DIR/shell/extensions.dconf"
APP_SWITCHER="$SCRIPT_DIR/shell/app-switcher.dconf"

# Desktop
PERIPHERALS="$SCRIPT_DIR/desktop/peripherals.dconf"
INPUT_SOURCES="$SCRIPT_DIR/desktop/input-sources.dconf"

echo "Dumping GNOME settings..."

dconf dump /org/gnome/shell/extensions/ > $EXTENSIONS
dconf dump /org/gnome/shell/app-switcher/ > "$APP_SWITCHER"
dconf dump /org/gnome/desktop/peripherals/ > "$PERIPHERALS"
dconf dump /org/gnome/desktop/input-sources/ > "$INPUT_SOURCES"

echo "Dumped GNOME settings to:"
echo "  $EXTENSIONS"
echo "  $APP_SWITCHER"
echo "  $PERIPHERALS"
echo "  $INPUT_SOURCES"
