#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -d "$SCRIPT_DIR" ]; then
	echo "Error: Script directory $SCRIPT_DIR does not exist."
	exit 1
fi

if [ ! -w "$SCRIPT_DIR" ]; then
	echo "Error: Script directory $SCRIPT_DIR is not writable."
	exit 1
fi

dconf dump /org/gnome/ >"$SCRIPT_DIR/settings.dconf"

echo "Dumped all GNOME settings to:"
echo "  $SCRIPT_DIR/settings.dconf"
