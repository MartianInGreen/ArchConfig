#!/bin/bash
set -e

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Install ArchConfig

printf "${CYAN}Installing ArchConfig...${RESET}\n"
printf "${YELLOW}Ensuring necessary directories exist...${RESET}\n"

# Ensure necessary directories exist
mkdir -p ~/.archconfig
mkdir -p ~/.archconfig/backups
mkdir -p ~/.archconfig/user
mkdir -p ~/.secrets
mkdir -p ~/.local/bin

# Ensure the necessary requirements are installed
printf "${YELLOW}Ensuring necessary requirements are installed...${RESET}\n"
sudo pacman -S rsync git vim dialog --noconfirm

# Git clone the repository to ~/.archconfig
printf "${YELLOW}Git cloning the repository to ~/.archconfig/source...${RESET}\n"
# Check if the repository already exists
if [ -d ~/.archconfig/source ]; then
    printf "${YELLOW}Repository already exists, pulling latest changes...${RESET}\n"
    cd ~/.archconfig/source
    git pull
else
    gh repo clone https://github.com/MartianInGreen/ArchConfig.git ~/.archconfig/source 
fi

# Copy files to the right places
printf "${YELLOW}Copying files to the right places...${RESET}\n"
cp ~/.archconfig/source/config.sh ~/.archconfig/config.sh
cp ~/.archconfig/source/main.sh ~/.archconfig/main.sh
cp -r ~/.archconfig/source/modules/ ~/.archconfig/modules/

# Make the main.sh executable
printf "${YELLOW}Making the main.sh executable...${RESET}\n"
chmod +x ~/.archconfig/source/main.sh

# Add a symlink to the main.sh file to ~/local/bin/archconfig (if it doesn't exist)
printf "${GREEN}Adding a symlink to the main.sh file to ~/local/bin/archconfig...${RESET}\n"
ln -s ~/.archconfig/source/main.sh ~/.local/bin/archconfig || true

# Print the message
printf "\n\n${GREEN}ArchConfig installed successfully${RESET}\n"
printf "You can now use the ${CYAN}archconfig${RESET} command to manage your Arch Linux configuration"
echo "To use the command, you need to add ~/.local/bin to your PATH"
echo "To add it to your PATH, run the following command:"
printf "${YELLOW}echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc${RESET}\n"
printf "${YELLOW}source ~/.bashrc${RESET}\n"