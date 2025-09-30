#!/bin/bash

# Update the system 
system_update() {
    printf "${CYAN}Updating the system...${RESET}\n"
    printf "${Green}⬇️⬇️⬇️ Pulling News...${RESET}\n"
    yay -Pw 
    printf "${GREEN}⬆️⬆️⬆️ News pulled successfully!${RESET}\n"
    printf "${YELLOW}Do you want to update the system? (y/n): ${RESET}"
    read update_system
    if [ "$update_system" == "y" ]; then
        printf "${CYAN}Updating the system...${RESET}\n"
        yay -Syu
        printf "${GREEN}System updated successfully!${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
}

# Main menu loop
system_update