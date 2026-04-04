# Linux Setup Tool

Linux bootstrap scripts for Ubuntu, Debian, and Arch systems.

The repository is organized into a minimal base layer for servers and a full CLI utility layer for
desktop setups. The installation can be done from source or via a one-liner curl command, with
options for unattended mode and selective installation.

## Features

The repository has two installation entrypoints:

- `./install.sh` installs small, server-safe CLI tools.
- `./install.sh --mode full` runs the base install first and then adds extra CLI utilities such as `lazygit`,
  `lazydocker`, `fzf`, `uv`, `yazi`, Docker tooling, and related tools.

## Prerequisites

- A fresh Ubuntu/Debian or Arch Linux installation
- Internet connection
- sudo privileges
- SSH connectivity for remote servers (GitHub)

## Clone the repository

```sh
git clone https://github.com/tpantsar/setup.git ~/setup
cd ~/setup
```

## SSH keys

Setup SSH keys for GitHub if you haven't already:

With curl:

- You can generate a token at: https://github.com/settings/personal-access-tokens/new
- Add account permissions to Git SSH keys read and write
- Check SSH keys at: https://github.com/settings/keys
- Add `GITHUB_TOKEN` to your environment variables:

```sh
export GITHUB_TOKEN=githup_pat
install/ssh-curl.sh
```

With GitHub CLI:

```sh
install/ssh-gh.sh
```

## Install from source

Base install:

```bash
./install.sh
```

Full utility install:

```bash
./install.sh --mode full
```

Examples:

```sh
./install.sh
./install.sh --help
./install.sh --mode full
MODE=full ./install.sh
```

## Install with curl

Base install:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/setup/main/install.sh)"
```

Full install:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/setup/main/install.sh)" --mode full
```

## Layering

`./install.sh` focuses on common packages that are safe defaults on Linux servers:

- Docker
- package manager refresh
- `fzf`, `eza`, `zoxide`, `starship`
- `curl`, `git`, `ripgrep`, `tmux`, `vim`, `tree`, `jq`
- Python venv and pip support

`./install.sh --mode full` adds optional utility tooling on top of that base:

- `lazygit`, `lazydocker`, `yazi`
- `uv`, Go, Neovim, GitHub/GitLab CLIs

Desktop environment setup, GUI apps, and personal workstation customization are intentionally not
part of the default install path.

## Resources

- [Linux post-installation steps for Docker Engine](https://docs.docker.com/engine/install/linux-postinstall/)
