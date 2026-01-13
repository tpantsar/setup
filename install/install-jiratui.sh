#!/bin/bash
# TUI interface for Atlassian JIRA
# https://jiratui.sh/getting-started.html

if ! command -v uv >/dev/null 2>&1; then
  echo "uv not found. Install it first."
  exit 1
fi

if command -v jiratui >/dev/null 2>&1; then
  echo "jiratui is already installed. Skipping."
  exit 0
fi

uv tool install jiratui
touch $HOME/.config/jiratui/config.yaml
echo "jiratui installed successfully."
jiratui version
echo "Edit the config file at ~/.config/jiratui/config.yaml to set up your JIRA instance."
echo "See https://jiratui.sh/getting-started.html for more information."
