#!/bin/bash

if command -v xdg-settings >/dev/null 2>&1; then
  if xdg-settings set default-web-browser firefox.desktop; then
    echo "Default browser set to Firefox"
  else
    echo "xdg-settings failed; skipping default browser setup"
  fi
else
  echo "xdg-settings not found; skipping default browser setup"
fi
