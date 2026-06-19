echo "Starting Base setup..."
sudo timedatectl set-timezone Europe/Helsinki

bash "$SETUP_INSTALL/bypass-sudo.sh"
bash "$SETUP_INSTALL/setup-permissions.sh"
bash "$SETUP_INSTALL/ssh-keygen.sh"

ensure_github_cli

bash "$SETUP_INSTALL/ssh-gh.sh"
bash "$SETUP_INSTALL/dotfiles.sh"
bash "$SETUP_INSTALL/tailscale.sh"

echo "Base setup completed."
