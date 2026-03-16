# Linux Setup Tool

Linux bootstrap scripts for Ubuntu, Debian, and Arch systems.

The repository is organized into a minimal base layer for servers and a fuller CLI utility layer
for developer machines and admin boxes.

## Features

The repository has two installation entrypoints:

- `./base.sh` installs a small, server-safe CLI foundation.
- `./install.sh` runs the base install first and then adds extra CLI utilities such as `lazygit`,
  `lazydocker`, `fzf`, `uv`, `yazi`, Docker tooling, and related helpers.

## Prerequisites

- A fresh Ubuntu/Debian or Arch Linux installation
- Internet connection
- sudo privileges

## Install from source

Base install:

```bash
git clone https://github.com/tpantsar/setup.git ~/setup/
cd ~/setup/
./install.sh --mode base
```

Full utility install:

```bash
git clone https://github.com/tpantsar/setup.git ~/setup/
cd ~/setup/
./install.sh
```

Examples:

```sh
./install.sh
./install.sh --mode base
MODE=base ./install.sh
```

## Install with curl

Base install:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/setup/main/install.sh)" "" --unattended --mode base
```

Full install:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/setup/main/install.sh)" "" --unattended
```

## Layering

`base.sh` focuses on common packages that are safe defaults on Linux servers:

- package manager refresh
- `curl`, `git`, `ripgrep`, `tmux`, `vim`, `tree`, `jq`
- Python venv and pip support

`install.sh` adds optional utility tooling on top of that base:

- `lazygit`, `lazydocker`, Docker
- `fzf`, `yazi`, `eza`, `zoxide`, `starship`
- `uv`, Go, Neovim, GitHub/GitLab CLIs

Desktop environment setup, GUI apps, and personal workstation customization are intentionally not
part of the default install path anymore.

## Resources

- [Linux post-installation steps for Docker Engine](https://docs.docker.com/engine/install/linux-postinstall/)
