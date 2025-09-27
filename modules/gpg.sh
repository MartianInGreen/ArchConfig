#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# Function to create a new GPG key
create_gpg_key() {
    printf "${CYAN}Creating a new GPG key...${RESET}\n"
    gpg --full-generate-key
    printf "${GREEN}GPG key created successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to create a new GPG subkey
create_gpg_subkey() {
    printf "${CYAN}Creating a new GPG subkey...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to add a subkey to: ${RESET}"
    read key_id
    gpg --edit-key "$key_id" addkey save
    printf "${GREEN}GPG subkey created successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to create a new GPG identity (UID)
create_gpg_identity() {
    printf "${CYAN}Creating a new GPG identity...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to add an identity to: ${RESET}"
    read key_id
    gpg --edit-key "$key_id" adduid save
    printf "${GREEN}GPG identity created successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to import GPG key from file
import_gpg_key_file() {
    printf "${CYAN}Importing GPG key from file...${RESET}\n"
    printf "${YELLOW}Enter the path to the GPG key file: ${RESET}"
    read file_path
    if [ -f "$file_path" ]; then
        gpg --import "$file_path"
        printf "${GREEN}GPG key imported successfully!${RESET}\n"
    else
        printf "${RED}File not found: $file_path${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to import GPG key from clipboard
import_gpg_key_clipboard() {
    printf "${CYAN}Importing GPG key from clipboard...${RESET}\n"
    if command -v xclip &> /dev/null; then
        xclip -selection clipboard -out | gpg --import
        printf "${GREEN}GPG key imported from clipboard successfully!${RESET}\n"
    elif command -v wl-paste &> /dev/null; then
        wl-paste | gpg --import
        printf "${GREEN}GPG key imported from clipboard successfully!${RESET}\n"
    else
        printf "${RED}No clipboard utility found (xclip or wl-paste required)${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to delete a GPG key
delete_gpg_key() {
    printf "${CYAN}Deleting a GPG key...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to delete: ${RESET}"
    read key_id
    printf "${RED}Are you sure you want to delete this key? (y/N): ${RESET}"
    read confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        gpg --delete-secret-keys "$key_id"
        gpg --delete-keys "$key_id"
        printf "${GREEN}GPG key deleted successfully!${RESET}\n"
    else
        printf "${YELLOW}Operation cancelled.${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to delete a GPG subkey
delete_gpg_subkey() {
    printf "${CYAN}Deleting a GPG subkey...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the main key ID: ${RESET}"
    read key_id
    gpg --edit-key "$key_id" key 1 delkey save
    printf "${GREEN}GPG subkey deleted successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to delete a GPG identity
delete_gpg_identity() {
    printf "${CYAN}Deleting a GPG identity...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID: ${RESET}"
    read key_id
    gpg --edit-key "$key_id" uid 1 deluid save
    printf "${GREEN}GPG identity deleted successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to list GPG keys
list_gpg_keys() {
    printf "${CYAN}Listing GPG keys...${RESET}\n"
    gpg --list-keys --keyid-format LONG
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to list GPG private keys
list_gpg_private_keys() {
    printf "${CYAN}Listing GPG private keys...${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to export GPG key to file
export_gpg_key_file() {
    printf "${CYAN}Exporting GPG key to file...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to export: ${RESET}"
    read key_id
    printf "${YELLOW}Enter the output file path: ${RESET}"
    read output_file
    gpg --export "$key_id" > "$output_file"
    printf "${GREEN}GPG key exported to $output_file successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to export GPG key to clipboard
export_gpg_key_clipboard() {
    printf "${CYAN}Exporting GPG key to clipboard...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to export: ${RESET}"
    read key_id
    if command -v xclip &> /dev/null; then
        gpg --export "$key_id" | xclip -selection clipboard
        printf "${GREEN}GPG key exported to clipboard successfully!${RESET}\n"
    elif command -v wl-copy &> /dev/null; then
        gpg --export "$key_id" | wl-copy
        printf "${GREEN}GPG key exported to clipboard successfully!${RESET}\n"
    else
        printf "${RED}No clipboard utility found (xclip or wl-copy required)${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to export GPG public key to file
export_gpg_public_key_file() {
    printf "${CYAN}Exporting GPG public key to file...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to export: ${RESET}"
    read key_id
    printf "${YELLOW}Enter the output file path: ${RESET}"
    read output_file
    gpg --armor --export "$key_id" > "$output_file"
    printf "${GREEN}GPG public key exported to $output_file successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to export GPG public key to clipboard
export_gpg_public_key_clipboard() {
    printf "${CYAN}Exporting GPG public key to clipboard...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to export: ${RESET}"
    read key_id
    if command -v xclip &> /dev/null; then
        gpg --armor --export "$key_id" | xclip -selection clipboard
        printf "${GREEN}GPG public key exported to clipboard successfully!${RESET}\n"
    elif command -v wl-copy &> /dev/null; then
        gpg --armor --export "$key_id" | wl-copy
        printf "${GREEN}GPG public key exported to clipboard successfully!${RESET}\n"
    else
        printf "${RED}No clipboard utility found (xclip or wl-copy required)${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to export GPG private key to file
export_gpg_private_key_file() {
    printf "${CYAN}Exporting GPG private key to file...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to export: ${RESET}"
    read key_id
    printf "${YELLOW}Enter the output file path: ${RESET}"
    read output_file
    printf "${RED}WARNING: This will export your private key. Make sure to store it securely!${RESET}\n"
    printf "${RED}Are you sure you want to continue? (y/N): ${RESET}"
    read confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        gpg --armor --export-secret-keys "$key_id" > "$output_file"
        printf "${GREEN}GPG private key exported to $output_file successfully!${RESET}\n"
        printf "${RED}Remember to keep this file secure and delete it when no longer needed!${RESET}\n"
    else
        printf "${YELLOW}Operation cancelled.${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
}

# Function to export GPG private key to clipboard
export_gpg_private_key_clipboard() {
    printf "${CYAN}Exporting GPG private key to clipboard...${RESET}\n"
    printf "${YELLOW}Available keys:${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to export: ${RESET}"
    read key_id
    printf "${RED}WARNING: This will export your private key to clipboard. Make sure to clear clipboard after use!${RESET}\n"
    printf "${RED}Are you sure you want to continue? (y/N): ${RESET}"
    read confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        if command -v xclip &> /dev/null; then
            gpg --armor --export-secret-keys "$key_id" | xclip -selection clipboard
            printf "${GREEN}GPG private key exported to clipboard successfully!${RESET}\n"
        elif command -v wl-copy &> /dev/null; then
            gpg --armor --export-secret-keys "$key_id" | wl-copy
            printf "${GREEN}GPG private key exported to clipboard successfully!${RESET}\n"
        else
            printf "${RED}No clipboard utility found (xclip or wl-copy required)${RESET}\n"
        fi
        printf "${RED}Remember to clear your clipboard when done!${RESET}\n"
    else
        printf "${YELLOW}Operation cancelled.${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
}

# Main menu loop
# Print the options

printf "${CYAN}GPG management module${RESET}\n"
printf "${YELLOW}Select an option:${RESET}\n\n"
printf "${CYAN}1. Key Management${RESET}\n"
printf "${GREEN}    11) Create a new GPG key${RESET}\n"
printf "${GREEN}    12) Create a new GPG subkey${RESET}\n"
printf "${GREEN}    13) Create a new GPG identity${RESET}\n"
printf "${GREEN}    14) Import GPG key from file${RESET}\n"
printf "${GREEN}    15) Import GPG key from clipboard${RESET}\n"
printf "${GREEN}    16) Delete a GPG key${RESET}\n"
printf "${GREEN}    17) Delete a GPG subkey${RESET}\n"
printf "${GREEN}    18) Delete a GPG identity${RESET}\n"
printf "${CYAN}2. Key Export${RESET}\n"
printf "${GREEN}    21) Export GPG key to file${RESET}\n"
printf "${GREEN}    22) Export GPG key to clipboard${RESET}\n"
printf "${GREEN}    23) Export GPG public key to file${RESET}\n"
printf "${GREEN}    24) Export GPG public key to clipboard${RESET}\n"
printf "${GREEN}    25) Export GPG private key to file${RESET}\n"
printf "${GREEN}    26) Export GPG private key to clipboard${RESET}\n"
printf "${CYAN}3. Key List${RESET}\n"
printf "${GREEN}    31) List GPG keys${RESET}\n"
printf "${GREEN}    32) List GPG private keys${RESET}\n"
printf "${GREEN}    33) List GPG identities${RESET}\n"
printf "${CYAN}4. Exit${RESET}\n"
printf "${GREEN}    41) Exit${RESET}\n"

# Get the user's choice
printf "Enter your choice: "
read choice

# Process the user's choice
case $choice in
    11) create_gpg_key;;
    12) create_gpg_subkey;;
    13) create_gpg_identity;;
    14) import_gpg_key_file;;
    15) import_gpg_key_clipboard;;
    16) delete_gpg_key;;
    17) delete_gpg_subkey;;
    18) delete_gpg_identity;;
    21) export_gpg_key_file;;
    22) export_gpg_key_clipboard;;
    23) export_gpg_public_key_file;;
    24) export_gpg_public_key_clipboard;;
    25) export_gpg_private_key_file;;
    26) export_gpg_private_key_clipboard;;
    31) list_gpg_keys;;
    32) list_gpg_private_keys;;
    33) list_gpg_identities;;
    41) exit;;
    *) printf "${RED}Invalid choice. Please try again.${RESET}\n";;
esac