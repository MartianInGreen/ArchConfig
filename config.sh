# Config file for ArchConfig

# Application variables
# ------------------------------------------------------------
# Version
VERSION="0.1-alpha"

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'
# ------------------------------------------------------------

# Path variables
# ------------------------------------------------------------
# Path to store the backups in 
BACKUPS_PATH="$HOME/.archconfig/backups"
BACKUP_METHOD="git"

# Git path 
GIT_PATH="$HOME/.archconfig/source"
INSTALL_PATH="$HOME/.archconfig"
# ------------------------------------------------------------

# User preferences
# ------------------------------------------------------------
# Files and directories to backup (using arrays)
BACKUP_FILES=("$HOME/.archconfig/config.sh" "$HOME/.zshrc")
BACKUP_FILES_ENCRYPTED=("$HOME/.ssh/id_rsa" "$HOME/.ssh/id_rsa.pub")
BACKUP_DIRS=("$HOME/.config/")
BACKUP_DIRS_ENCRYPTED=("$HOME/.ssh/" "$HOME/.secrets/")
# GPG and SSH key IDs to backup (leave empty if no keys to backup)
BACKUP_GPG_KEY_IDS=()
BACKUP_SSH_KEY_IDS=()

SECRETS_PATH="$HOME/.secrets/archconfig.secrets"
# ------------------------------------------------------------