#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f "$SCRIPT_DIR/settings.dconf" ]; then
    echo "Error: settings.dconf file not found in $SCRIPT_DIR"
    echo "Please run the dump script first to create this file."
    echo "$SCRIPT_DIR/dump-all.sh"
    exit 1
fi

dconf load /org/gnome/ < "$SCRIPT_DIR/settings.dconf"

echo "Loaded all GNOME settings from:"
echo "  $SCRIPT_DIR/settings.dconf"
