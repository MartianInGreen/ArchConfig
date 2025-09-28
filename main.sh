#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# Argument Parsing
# ------------------------------------------------------------
# -h, --help

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: archconfig [command]"
    echo "Commands:"
    echo "  update     Update the ArchConfig application"
    echo "  gpg        Launch the GPG management module"
    echo "  backup     Launch the backup management module"
    echo "  git        Launch the git management module"
    echo "  setup      Launch the setup management module"
    echo "  help       Show this help message"
    exit 0
fi

# Update the ArchConfig repository
if [ "$1" == "update" ]; then
    source ~/.archconfig/modules/update.sh
    exit 0
fi

# Launch the GPG module
if [ "$1" == "gpg" ]; then
    source ~/.archconfig/modules/gpg.sh
    exit 0
fi

# Launch the backup module
if [ "$1" == "backup" ]; then
    source ~/.archconfig/modules/backup.sh
    exit 0
fi

# Launch the git module
if [ "$1" == "git" ]; then
    source ~/.archconfig/modules/git.sh
    exit 0
fi

# Launch the setup module
if [ "$1" == "setup" ]; then
    source ~/.archconfig/modules/setup.sh
    exit 0
fi

# -----------------------------------------------------------------

# Main menu
printf "${CYAN}ArchConfig${RESET}\n"
printf "${YELLOW}Select an option:${RESET}\n\n"

printf "${CYAN}1. Management${RESET}\n"
printf "${GREEN}    11) Fixes${RESET}\n"
printf "${GREEN}    12) Backup${RESET}\n"
printf "${CYAN}2. Tools${RESET}\n"
printf "${GREEN}    21) GPG Management${RESET}\n"
printf "${GREEN}    22) Git Management${RESET}\n"
printf "${GREEN}    23) Setup Management${RESET}\n"
printf "${CYAN}3. Exit${RESET}\n"
printf "${GREEN}    9) Exit${RESET}\n"

# Get the user's choice
printf "Enter your choice: "
read choice

# Process the user's choice
case $choice in
    11) source ~/.archconfig/modules/fixes.sh;;
    12) source ~/.archconfig/modules/backup.sh;;
    21) source ~/.archconfig/modules/gpg.sh;;
    22) source ~/.archconfig/modules/git.sh;;
    23) source ~/.archconfig/modules/setup.sh;;
    9) exit;;
    *) printf "${RED}Invalid choice. Please try again.${RESET}\n";;
esac

# -----------------------------------------------------------------