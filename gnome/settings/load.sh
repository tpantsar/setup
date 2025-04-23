#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Shell
EXTENSIONS="$SCRIPT_DIR/shell/extensions.dconf"
APP_SWITCHER="$SCRIPT_DIR/shell/app-switcher.dconf"

# Desktop
PERIPHERALS="$SCRIPT_DIR/desktop/peripherals.dconf"
INPUT_SOURCES="$SCRIPT_DIR/desktop/input-sources.dconf"

echo "Loading GNOME settings..."

dconf load /org/gnome/shell/extensions/ < $EXTENSIONS
dconf load /org/gnome/shell/app-switcher/ < "$APP_SWITCHER"
dconf load /org/gnome/desktop/peripherals/ < "$PERIPHERALS"
dconf load /org/gnome/desktop/input-sources/ < "$INPUT_SOURCES"

echo "Loaded GNOME settings from:"
echo "  $EXTENSIONS"
echo "  $APP_SWITCHER"
echo "  $PERIPHERALS"
echo "  $INPUT_SOURCES"
