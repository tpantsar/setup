# https://www.agwa.name/projects/git-crypt/
if ! command -v git-crypt &>/dev/null; then
  echo "Installing git-crypt ..."
  TARBALL="/tmp/git-crypt.tar.gz"
  curl -Lo ${TARBALL} "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.8.0.tar.gz"
  tar -xzf "$TARBALL" -C /tmp
  cd /tmp/git-crypt-*
  make
  sudo make install PREFIX=/usr/local
  rm -rf /tmp/git-crypt-*
  git-crypt --version
  echo "git-crypt installed successfully."
else
  echo "git-crypt is already installed"
fi
