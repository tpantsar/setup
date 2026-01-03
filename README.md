# Linux Setup Tool 🛠️

Linux System Tool that automates the setup and configuration of Ubuntu/Debian/Arch based Linux systems.  
It installs and configures packages, desktop environments, and various utilities to create a fully functional development environment.

## Features

- 🔄 Automated system updates
- 📦 Package installation
- ⚙️ Automatic service configuration
- 🎮 Flatpak integration for specific applications
- 🖥️ GNOME desktop environment setup with tiling-like features
- 🔧 GNOME extensions and hotkey configuration

## Prerequisites

- A fresh Ubuntu/Debian or Arch Linux installation
- Internet connection
- sudo privileges

## Installation

From source:

```bash
git clone https://github.com/tpantsar/setup.git ~/setup/
cd ~/setup/
./install.sh
```

Install with curl:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tpantsar/setup/main/install.sh)" "" --unattended
```

Follow the prompts to select the packages you want to install.

The script will handle the rest of the setup process.

After the setup is complete, you can reboot your system to see the changes.

## Resources

- [Linux post-installation steps for Docker Engine](https://docs.docker.com/engine/install/linux-postinstall/)
