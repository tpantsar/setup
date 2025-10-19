sudo pacman -Syu --noconfirm --needed git

# Use custom repo if specified, otherwise default to tpantsar/setup
SETUP_REPO="${SETUP_REPO:-tpantsar/setup}"

echo -e "\nCloning setup from: https://github.com/${SETUP_REPO}.git"
rm -rf ~/.local/share/setup/
git clone "https://github.com/${SETUP_REPO}.git" ~/.local/share/setup >/dev/null

# Use custom branch if instructed, otherwise default to main
SETUP_REF="${SETUP_REF:-main}"
if [[ $SETUP_REF != "main" ]]; then
  echo -e "\e[32mUsing branch: $SETUP_REF\e[0m"
  cd ~/.local/share/setup
  git fetch origin "${SETUP_REF}" && git checkout "${SETUP_REF}"
  cd -
fi
