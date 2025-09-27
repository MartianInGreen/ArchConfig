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
while true; do
    clear
    choice=$(dialog --clear --title "GPG Module" --menu "Select an option:" 20 60 15 \
        "1" "Create a new GPG key" \
        "11" "Create a new GPG subkey" \
        "12" "Create a new GPG identity" \
        "21" "Import a GPG key from a file" \
        "22" "Import a GPG key from clipboard" \
        "3" "Delete a GPG key" \
        "31" "Delete a GPG subkey" \
        "32" "Delete a GPG identity" \
        "4" "List GPG keys" \
        "41" "List GPG private keys" \
        "61" "Export a GPG key to a file" \
        "62" "Export a GPG key to clipboard" \
        "71" "Export a GPG public key to a file" \
        "72" "Export a GPG public key to clipboard" \
        "73" "Export a GPG private key to a file" \
        "74" "Export a GPG private key to clipboard" \
        "8" "Back" \
        2>&1 >/dev/tty)

    # Handle dialog cancellation
    if [ $? -ne 0 ]; then
        break
    fi

    case $choice in
        1)
            clear
            create_gpg_key
            ;;
        11)
            clear
            create_gpg_subkey
            ;;
        12)
            clear
            create_gpg_identity
            ;;
        21)
            clear
            import_gpg_key_file
            ;;
        22)
            clear
            import_gpg_key_clipboard
            ;;
        3)
            clear
            delete_gpg_key
            ;;
        31)
            clear
            delete_gpg_subkey
            ;;
        32)
            clear
            delete_gpg_identity
            ;;
        4)
            clear
            list_gpg_keys
            ;;
        41)
            clear
            list_gpg_private_keys
            ;;
        61)
            clear
            export_gpg_key_file
            ;;
        62)
            clear
            export_gpg_key_clipboard
            ;;
        71)
            clear
            export_gpg_public_key_file
            ;;
        72)
            clear
            export_gpg_public_key_clipboard
            ;;
        73)
            clear
            export_gpg_private_key_file
            ;;
        74)
            clear
            export_gpg_private_key_clipboard
            ;;
        8)
            break
            ;;
        *)
            printf "${RED}Invalid option. Please try again.${RESET}\n"
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
    esac
done

clear
