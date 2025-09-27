#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# Setup fprint for sudo and login with fingerprint on Arch
setup_fingerprint() {
    printf "${CYAN}Setting up fingerprint for sudo and login...${RESET}\n"
    sudo pacman -S fprintd --noconfirm

    # Enroll left and right index finger
    printf "${YELLOW}Enrolling right index finger...${RESET}\n"
    fprintd-enroll -f "right-index-finger"
    printf "${YELLOW}Enrolling left index finger...${RESET}\n"
    fprintd-enroll -f "left-index-finger"

    # Editing files 
    printf "${YELLOW}Editing files...${RESET}\n"
    printf "${RED}Please put `auth 		sufficient  	pam_fprintd.so` before any other auth methods in the next files that will be open. Insert after pressing i then press ESC and then :wq.${RESET}\n"

    printf "${YELLOW}Press any key to continue...${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."

    # Open files
    printf "${YELLOW}Opening files...${RESET}\n"
    sudo vim /etc/pam.d/sudo
    sudo vim /etc/pam.d/su
    sudo vim /etc/pam.d/system-local-login

    printf "${GREEN}Files edited successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."

    # Setup complete
    printf "${GREEN}Setup complete!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Main menu loop
# Print the options

printf "${CYAN}Setup module${RESET}\n"
printf "${YELLOW}Select an option:${RESET}\n\n"
printf "${CYAN}1. Setup Fingerprint${RESET}\n"
printf "${GREEN}    11) Setup fingerprint${RESET}\n"
printf "${CYAN}9. Exit${RESET}\n"
printf "${GREEN}    91) Exit${RESET}\n"

# Get the user's choice
printf "Enter your choice: "
read choice