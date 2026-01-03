#!/bin/bash
# https://docs.docker.com/engine/install/linux-postinstall/

USER_TO_ADD="${1:-$USER}"
SUDOERS_FILE="/etc/sudoers.d/$USER_TO_ADD"
SUDO_RULE="$USER_TO_ADD ALL=(ALL) NOPASSWD:ALL"

# Check if file already exists and contains the correct line
if sudo test -f "$SUDOERS_FILE" && sudo grep -qF "$SUDO_RULE" "$SUDOERS_FILE"; then
  echo "Passwordless sudo already configured in $SUDOERS_FILE"
  exit 0
fi

echo "Configuring passwordless sudo for: $USER_TO_ADD"

# Write the rule to a temp file
TMP_FILE=$(mktemp)
echo "$SUDO_RULE" >"$TMP_FILE"

# Validate syntax
if sudo visudo -c -f "$TMP_FILE"; then
  echo "Sudoers file syntax is valid."
  sudo cp "$TMP_FILE" "$SUDOERS_FILE"
  sudo chmod 0440 "$SUDOERS_FILE"
  echo "Passwordless sudo successfully configured at $SUDOERS_FILE"
else
  echo "Invalid syntax in sudoers file. Aborting."
  echo "Removing temporary file."
  rm -rf "$TMP_FILE"
  exit 1
fi

echo "Removing temporary file."
rm -rf "$TMP_FILE"

exit 0
