#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Dumping GNOME settings..."

# Shell
EXTENSIONS="$SCRIPT_DIR/shell/extensions.dconf"
APP_SWITCHER="$SCRIPT_DIR/shell/app-switcher.dconf"

dconf dump /org/gnome/shell/extensions/ > $EXTENSIONS
dconf dump /org/gnome/shell/app-switcher/ > "$APP_SWITCHER"

# Desktop
PERIPHERALS="$SCRIPT_DIR/desktop/peripherals.dconf"
INPUT_SOURCES="$SCRIPT_DIR/desktop/input-sources.dconf"
WM="$SCRIPT_DIR/desktop/wm.dconf"

dconf dump /org/gnome/desktop/peripherals/ > "$PERIPHERALS"
dconf dump /org/gnome/desktop/input-sources/ > "$INPUT_SOURCES"
dconf dump /org/gnome/desktop/wm/ > "$WM"

echo "Dumped GNOME settings to:"
echo "  $EXTENSIONS"
echo "  $APP_SWITCHER"
echo "  $PERIPHERALS"
echo "  $INPUT_SOURCES"
echo "  $WM"
