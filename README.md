# Linux Setup Tool 🛠️

Linux System Tool that automates the setup and configuration of Ubuntu/Debian/Arch based Linux
systems.

It installs and configures packages, desktop environments, and various utilities to create a fully
functional development environment.

## Features

The repository has two installation entrypoints:

- `./base.sh` installs a minimal, server-safe CLI foundation.
- `./install.sh` runs the base install first and then adds the full utility layer with tools such as
  `lazygit`, `lazydocker`, `fzf`, `uv`, `nvm`, `yazi`, and related developer utilities.

## Prerequisites

- A fresh Ubuntu/Debian or Arch Linux installation
- Internet connection
- sudo privileges

## Installation

Base install

```bash
git clone https://github.com/tpantsar/setup.git ~/setup/
cd ~/setup/
./base.sh
```

Full utility install

```bash
git clone https://github.com/tpantsar/setup.git ~/setup/
cd ~/setup/
./install.sh
```

With curl

```sh
# base
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/setup/main/base.sh)" "" --unattended

# full
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/setup/main/install.sh)" "" --unattended
```

The full install reuses the base install, so you can use `./base.sh` for lightweight server
provisioning and `./install.sh` to add the extra utility toolchain later.

## Resources

- [Linux post-installation steps for Docker Engine](https://docs.docker.com/engine/install/linux-postinstall/)
