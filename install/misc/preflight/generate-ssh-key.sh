SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_ed25519"

if [ -f "$KEY_FILE" ]; then
  info "SSH key already exists at $KEY_FILE"
else
  read -p "Enter your GitHub email for SSH key: " EMAIL
  mkdir -p "$SSH_DIR"
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_FILE" -N ""
  eval "$(ssh-agent -s)"
  ssh-add "$KEY_FILE"
  success "SSH key generated successfully!"
  info "Your public key:"
  cat "${KEY_FILE}.pub"
fi
