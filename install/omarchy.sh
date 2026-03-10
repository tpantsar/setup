#!/bin/bash

# Define Omarchy locations
export OMARCHY_PATH="$HOME/.local/share/omarchy"
export OMARCHY_INSTALL="$OMARCHY_PATH/install"
export OMARCHY_INSTALL_LOG_FILE="/var/log/omarchy-install.log"
export PATH="$OMARCHY_PATH/bin:$PATH"

# Use custom repo if specified, otherwise default to basecamp/omarchy
OMARCHY_REPO="${OMARCHY_REPO:-basecamp/omarchy}"

# Use custom branch if instructed, otherwise default to master
OMARCHY_REF="${OMARCHY_REF:-master}"

update_omarchy() {
  if [ -d "$OMARCHY_PATH" ]; then
    echo "Omarchy is already installed at $OMARCHY_PATH, updating to the latest version ..."
    cd $OMARCHY_PATH
    git fetch origin "${OMARCHY_REF}" && git checkout "${OMARCHY_REF}"
    cd -
    echo "Updated Omarchy to the latest version on branch: ${OMARCHY_REF}"

    sudo touch "$OMARCHY_INSTALL_LOG_FILE"
    sudo chmod 666 "$OMARCHY_INSTALL_LOG_FILE"

    echo -e "\nRunning Omarchy scripts ..."
    source $OMARCHY_INSTALL/helpers/logging.sh
    run_logged $OMARCHY_INSTALL/preflight/first-run-mode.sh
    run_logged $OMARCHY_INSTALL/config/docker.sh
    bash "$OMARCHY_INSTALL/first-run/firewall.sh"
    echo -e "\nOmarchy installation and configuration complete!"

    exit 0
  fi

  echo "Omarchy installation failed."
  exit 1
}

if [ ! -d "$OMARCHY_PATH" ]; then
  echo "Omarchy not found at $OMARCHY_PATH, proceeding with installation ..."
  echo -e "\nCloning Omarchy from: https://github.com/${OMARCHY_REPO}.git"
  rm -rf ${OMARCHY_PATH}
  git clone "https://github.com/${OMARCHY_REPO}.git" $OMARCHY_PATH >/dev/null

  if [[ $OMARCHY_REF != "master" ]]; then
    echo -e "\e[32mUsing branch: $OMARCHY_REF\e[0m"
    cd $OMARCHY_PATH
    git fetch origin "${OMARCHY_REF}" && git checkout "${OMARCHY_REF}"
    cd -
  fi

  update_omarchy
  exit 0
fi

update_omarchy
