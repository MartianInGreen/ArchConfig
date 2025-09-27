#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# Set up git
set_up_git() {
    printf "${CYAN}Setting up git...${RESET}\n"
    printf "${YELLOW}Enter your name: ${RESET}"
    read name
    printf "${YELLOW}Enter your email: ${RESET}"
    read email
    git config --global user.name "$name"
    git config --global user.email "$email"

    # GPG? 
    printf "${YELLOW}Do you want to use GPG? (y/n): ${RESET}"
    read gpg
    if [ "$gpg" == "y" ]; then
        # List GPG key
        printf "${YELLOW}Available GPG keys:${RESET}\n"
        gpg --list-secret-keys --keyid-format LONG
        printf "${YELLOW}Enter your GPG key ID: ${RESET}"
        read gpg_key_id
        git config --global user.signingkey "$gpg_key_id"
    fi

    # SSH?
    printf "${YELLOW}Do you want to use SSH? (y/n): ${RESET}"
    read ssh
    if [ "$ssh" == "y" ]; then
        printf "${YELLOW}Enter your SSH key ID: ${RESET}"
        read ssh_key_id
        git config --global user.signingkey "$ssh_key_id"
    fi

    # Default editor 
    printf "${YELLOW}Do you want to use Vim as the default editor? (y/n): ${RESET}"
    read vim
    if [ "$vim" == "y" ]; then
        git config --global core.editor "vim"
    fi

    # Default branch
    printf "${YELLOW}Do you want to use main as the default branch? Default is master (y/n): ${RESET}"
    read main
    if [ "$main" == "y" ]; then
        git config --global init.defaultBranch "main"
    else
        git config --global init.defaultBranch "master"
    fi

    # Default pull behavior 
    printf "${YELLOW}Do you want to use rebase as the default pull behavior? Default is merge (y/n): ${RESET}"
    read rebase
    if [ "$rebase" == "y" ]; then
        git config --global pull.rebase true
    else
        git config --global pull.merge true
    fi

    # Install github-cli and login?
    printf "${YELLOW}Do you want to install github-cli and login? (y/n): ${RESET}"
    read github_cli
    if [ "$github_cli" == "y" ]; then
        sudo pacman -S github-cli --noconfirm
        gh auth login
    fi

    printf "${GREEN}Git setup complete!${RESET}\n"
}

set_local_git_config() {
    printf "${CYAN}Setting up local git config...${RESET}\n"
    printf "${YELLOW}Enter your name: ${RESET}"
    read name
    printf "${YELLOW}Enter your email: ${RESET}"
    read email
    git config --local user.name "$name"
    git config --local user.email "$email"

    # GPG?
    printf "${YELLOW}Do you want to use GPG? (y/n): ${RESET}"
    read gpg
    if [ "$gpg" == "y" ]; then
        printf "${YELLOW}Enter your GPG key ID: ${RESET}"
        read gpg_key_id
        git config --local user.signingkey "$gpg_key_id"
    fi

    # SSH?
    printf "${YELLOW}Do you want to use SSH? (y/n): ${RESET}"
    read ssh
    if [ "$ssh" == "y" ]; then
        printf "${YELLOW}Enter your SSH key ID: ${RESET}"
        read ssh_key_id
        git config --local user.signingkey "$ssh_key_id"
    fi

    printf "${GREEN}Local git config setup complete!${RESET}\n"
}

# Main menu loop
# Print the options

printf "${CYAN}Git module${RESET}\n"
printf "${YELLOW}Select an option:${RESET}\n\n"
printf "${CYAN}1. Global Git Config${RESET}\n"
printf "${GREEN}    11) Set up global git config${RESET}\n"
printf "${CYAN}2. Local Git Config${RESET}\n"
printf "${GREEN}    21) Set up local git config${RESET}\n"
printf "${CYAN}9. Exit${RESET}\n"
printf "${GREEN}    91) Exit${RESET}\n"

# Get the user's choice
printf "Enter your choice: "
read choice

# Process the user's choice
case $choice in
    11) set_up_git;;
    21) set_local_git_config;;
    91) exit;;
    *) printf "${RED}Invalid choice. Please try again.${RESET}\n";;
esac