#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

alacritty_input_fixes() {
    printf "${CYAN}Fixing Alacritty input...${RESET}\n"
    current_dir=$(pwd)
    cd ~/Downloads
    curl -L https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > alacritty.info
    sudo tic -x alacritty.info

    stty sane
    stty icrnl -inlcr -igncr

    cd $current_dir
    printf "${GREEN}Alacritty input fixed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Main menu loop
# Print the options

printf "${CYAN}Fixes module${RESET}\n"
printf "${YELLOW}Select an option:${RESET}\n\n"
printf "${CYAN}1. Terminal Fixes${RESET}\n"
printf "${GREEN}    11) Alacritty input fixes${RESET}\n"
printf "${CYAN}9. Exit${RESET}\n"
printf "${GREEN}    91) Exit${RESET}\n"

# Get the user's choice
printf "Enter your choice: "
read choice

# Process the user's choice
case $choice in
    11) alacritty_input_fixes;;
    91) exit;;
    *) printf "${RED}Invalid choice. Please try again.${RESET}\n";;
esac