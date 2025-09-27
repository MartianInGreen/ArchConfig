# ArchConfig

A comprehensive Arch Linux configuration management tool that helps you manage system configurations, backups, GPG keys, Git setup, and common fixes.

## Overview

ArchConfig is a modular bash-based tool designed to streamline the management of your Arch Linux system. It provides an interactive menu-driven interface for various system administration tasks including:

- **System Configuration Management**: Centralized configuration through `~/.archconfig/config.sh`
- **Automated Backups**: Git-based backup system for important files and directories
- **GPG Key Management**: Complete GPG key lifecycle management (creation, backup, restore)
- **Git Configuration**: Automated Git setup with GPG signing and SSH support
- **System Fixes**: Common terminal and application fixes (e.g., Alacritty input issues)

## Features

### 🔧 Management Tools
- **Fixes Module**: Resolve common system issues (Alacritty input fixes, etc.)
- **Backup Module**: Automated backup system with Git integration and encryption support
  - Daily automated backups via cron jobs
  - Separate handling for encrypted and non-encrypted files
  - GPG and SSH key backup support

### 🛠️ Development Tools
- **GPG Management**: Complete GPG key management suite
  - Create new GPG keys and subkeys
  - Manage GPG identities (UIDs)
  - Export and import keys
  - Backup and restore functionality
- **Git Management**: Streamlined Git configuration
  - User setup with name and email
  - GPG signing key configuration
  - SSH key integration

## Installation

### Prerequisites

The installer will automatically install required dependencies, but ensure you have:
- Arch Linux system
- Internet connection
- `sudo` privileges

### Quick Install

1. Clone the repository:
```bash
git clone https://github.com/MartianInGreen/ArchConfig.git
cd ArchConfig
```

2. Run the installer:
```bash
chmod +x install.sh
./install.sh
```

3. Add ArchConfig to your PATH:
```bash
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

### What the installer does:

1. **Creates necessary directories**:
   - `~/.archconfig/` - Main configuration directory
   - `~/.archconfig/backups/` - Backup storage
   - `~/.archconfig/user/` - User-specific configurations
   - `~/.secrets/` - Encrypted secrets storage
   - `~/.local/bin/` - Local binaries

2. **Installs dependencies**:
   - `rsync` - File synchronization
   - `git` - Version control
   - `vim` - Text editor
   - `dialog` - Interactive dialogs

3. **Sets up the application**:
   - Clones the repository to `~/.archconfig/source/`
   - Copies configuration files
   - Creates executable symlink at `~/.local/bin/archconfig`

## Usage

### Command Line Interface

After installation, you can use ArchConfig via the command line:

```bash
# Launch interactive menu
archconfig

# Update ArchConfig
archconfig update

# Launch GPG management directly
archconfig gpg

# Show help
archconfig --help
```

### Interactive Menu

The main interface provides organized access to all modules:

```
ArchConfig
Select an option:

1. Management
    11) Fixes
    12) Backup
2. Tools
    21) GPG Management
    22) Git Management
3. Exit
    9) Exit
```

### Configuration

The main configuration file is located at `~/.archconfig/config.sh`. Key settings include:

- **Backup Paths**: Configure which files and directories to backup
- **Encryption**: Specify files requiring GPG encryption
- **Git Settings**: Repository and installation paths
- **Secrets**: Path to encrypted secrets file

## Development

### Local Development Updates

For developers working on ArchConfig:

```bash
# Update local installation with current working directory changes
./devUpdate.sh
```

This script:
- Preserves your existing configuration
- Updates modules and main script
- Maintains executable permissions

### Project Structure

```
ArchConfig/
├── main.sh              # Main application entry point
├── config.sh            # Configuration template
├── install.sh           # Installation script
├── devUpdate.sh         # Development update script
└── modules/
    ├── backup.sh         # Backup management
    ├── fixes.sh          # System fixes
    ├── git.sh            # Git configuration
    ├── gpg.sh            # GPG key management
    └── update.sh         # Update functionality
```

## Backup System

ArchConfig includes a sophisticated backup system:

### Features
- **Git-based versioning**: All backups are version controlled
- **Encryption support**: Sensitive files are GPG encrypted
- **Automated scheduling**: Optional daily cron jobs
- **Selective backup**: Configure specific files and directories

### Backup Categories
- **Regular files**: Configuration files, dotfiles
- **Encrypted files**: SSH keys, sensitive configurations
- **Directories**: Complete directory structures
- **GPG/SSH Keys**: Cryptographic key materials

## Security

- Sensitive files are automatically encrypted using GPG
- SSH keys and secrets are handled separately from regular configurations
- Backup encryption uses your configured GPG keys
- All secrets are stored in `~/.secrets/` with restricted permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `./devUpdate.sh`
5. Submit a pull request

## License

This project is licensed under the terms specified in the LICENSE file.

## Version

Current version: 0.1-alpha

---

**Note**: This tool is designed specifically for Arch Linux systems. While some modules may work on other Linux distributions, full functionality is only guaranteed on Arch Linux.