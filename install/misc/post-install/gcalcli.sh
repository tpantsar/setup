info "Installing gcalcli..."

if [ -d "$HOME/gcalcli" ]; then
  info "gcalcli already installed, skipping..."
else
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/gcalcli/main/install.sh)" "" --unattended
  success "gcalcli installed."
fi
