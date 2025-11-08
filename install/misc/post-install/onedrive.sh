CONFIG_DIR="$HOME/.config/onedrive-personal"

if [ ! -f "$CONFIG_DIR/config" ]; then
  info "Setting up OneDrive personal config..."
  mkdir -p "$CONFIG_DIR"
  wget https://raw.githubusercontent.com/abraunegg/onedrive/master/config -O "$CONFIG_DIR/config"

  sed -i 's|^#\? *sync_dir *=.*|sync_dir = "~/OneDrive-Personal"|' "$CONFIG_DIR/config"
  sed -i 's|^#\? *skip_dir *=.*|skip_dir = ".*Temp.*"|' "$CONFIG_DIR/config"
  success "OneDrive config file created."
else
  info "OneDrive config already exists, skipping."
fi

systemctl --user enable onedrive-personal.service || true
systemctl --user start onedrive-personal.service || true
success "OneDrive service enabled and started."
