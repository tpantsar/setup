echo "Starting Desktop setup..."
bash "$SETUP_INSTALL/set-shell.sh"
bash "$SETUP_INSTALL/git-crypt.sh"
bash "$SETUP_INSTALL/gcalcli.sh"
bash "$SETUP_INSTALL/zk.sh"
bash "$SETUP_INSTALL/node.sh"

bash "$SETUP_INSTALL/neovim.sh"
bash "$SETUP_INSTALL/tmuxifier.sh"
bash "$SETUP_INSTALL/tpm.sh"
bash "$SETUP_INSTALL/treesitter.sh"
bash "$SETUP_INSTALL/atuin.sh"

bash "$HOME/bin/tmset"

echo "Desktop setup completed."
