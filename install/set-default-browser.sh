#!/bin/bash

BROWSER="firefox.desktop"

if command -v xdg-settings >/dev/null 2>&1; then
  if xdg-settings set default-web-browser $BROWSER; then
    echo "Default browser set to $BROWSER"
  else
    echo "xdg-settings failed; skipping default browser setup"
  fi
else
  echo "xdg-settings not found; skipping default browser setup"
fi
