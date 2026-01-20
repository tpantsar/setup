#!/bin/bash
# Set correct permissions for systemd directories

# These directories should be readable/traversable by normal users
sudo chown root:root /usr/lib/systemd /usr/lib/systemd/user
sudo chmod 755 /usr/lib/systemd /usr/lib/systemd/user

# ensure everything under the user unit tree is readable and dirs are traversable
sudo chmod -R a+rX /usr/lib/systemd/user
echo "Permissions for systemd directories have been set."

# Repair files properly by reinstalling systemd
# sudo apt-get install --reinstall systemd dbus
# sudo pacman -Syu --noconfirm --needed systemd dbus

echo "Verifying systemd and PulseAudio status:"
systemctl --user status --no-pager
pactl info
sudo systemctl status snapd snapd.socket --no-pager
echo "If there are permission issues with systemd or PulseAudio, consider reinstalling systemd and dbus."

echo
echo "Checking systemd-logind status:"
sudo systemctl status systemd-logind "user@$(id -u).service" --no-pager

echo "Recent logs for user@$(id -u).service:"
sudo journalctl -u "user@$(id -u).service" -b --no-pager | tail -n 200

echo
echo "Verifying permissions by listing systemd user default target:"
namei -l /usr/lib/systemd/user/default.target
ls -ld /usr/lib/systemd /usr/lib/systemd/user

echo
echo "Searching for dbus-launch, DBUS_SESSION_BUS_ADDRESS, or dbus-run-session in common config files:"
grep -R -n -E 'dbus-launch|DBUS_SESSION_BUS_ADDRESS|dbus-run-session' ~/.config/i3 ~/.xprofile ~/.xsession ~/.xsessionrc ~/.zshenv ~/.zprofile ~/.profile 2>/dev/null
echo "If any of these are found, consider removing them to avoid conflicts with systemd user sessions."

echo
echo "If any directories are not owned by root or do not have 755 permissions, please fix them."
echo "setup-permissions.sh completed."
