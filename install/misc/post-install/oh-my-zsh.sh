info "Installing Oh My Zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
  info "Oh My Zsh already installed, skipping..."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  sudo chsh -s "$(which zsh)" "$USER"
  success "Oh My Zsh installed."
fi
