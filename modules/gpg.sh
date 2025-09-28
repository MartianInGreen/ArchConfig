#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# Function to create a new GPG key
create_gpg_key() {
    printf "${CYAN}Creating a new GPG key...${RESET}\n"
    gpg --full-generate-key
    printf "${GREEN}GPG key created successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to list GPG keys
list_gpg_keys() {
    printf "${CYAN}Listing GPG keys...${RESET}\n"
    gpg --list-keys --keyid-format LONG
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to list GPG private keys
list_gpg_private_keys() {
    printf "${CYAN}Listing GPG private keys...${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to list GPG identities
list_gpg_identities() {
    printf "${CYAN}Listing GPG identities...${RESET}\n"
    printf "${YELLOW}Available keys and their identities:${RESET}\n"
    gpg --list-keys --with-colons | awk -F: '
    /^pub:/ { 
        key_id = $5; 
        printf "\n%sKey ID: %s%s\n", "'${CYAN}'", key_id, "'${RESET}'"
    }
    /^uid:/ { 
        uid = $10; 
        gsub(/%[0-9A-Fa-f][0-9A-Fa-f]/, "", uid);
        printf "%s  Identity: %s%s\n", "'${GREEN}'", uid, "'${RESET}'"
    }'
    printf "\n"
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to encrypt a file with a password with symmetric encryption
encrypt_file_password() {
    printf "${CYAN}Encrypting file with password (symmetric encryption)...${RESET}\n"
    printf "${YELLOW}Enter the path to the file to encrypt: ${RESET}"
    read input_file
    if [ ! -f "$input_file" ]; then
        printf "${RED}File not found: $input_file${RESET}\n"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    printf "${YELLOW}Enter the output file path (default: ${input_file}.gpg): ${RESET}"
    read output_file
    if [ -z "$output_file" ]; then
        output_file="${input_file}.gpg"
    fi
    gpg --cipher-algo AES256 --compress-algo 1 --s2k-digest-algo SHA512 --symmetric --output "$output_file" "$input_file"
    if [ $? -eq 0 ]; then
        printf "${GREEN}File encrypted successfully to: $output_file${RESET}\n"
    else
        printf "${RED}Encryption failed!${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to decrypt a file with a password with symmetric encryption
decrypt_file_password() {
    printf "${CYAN}Decrypting file with password (symmetric decryption)...${RESET}\n"
    printf "${YELLOW}Enter the path to the encrypted file: ${RESET}"
    read input_file
    if [ ! -f "$input_file" ]; then
        printf "${RED}File not found: $input_file${RESET}\n"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    printf "${YELLOW}Enter the output file path (default: ${input_file%.gpg}): ${RESET}"
    read output_file
    if [ -z "$output_file" ]; then
        output_file="${input_file%.gpg}"
        if [ "$output_file" = "$input_file" ]; then
            output_file="${input_file}.decrypted"
        fi
    fi
    gpg --decrypt --output "$output_file" "$input_file"
    if [ $? -eq 0 ]; then
        printf "${GREEN}File decrypted successfully to: $output_file${RESET}\n"
    else
        printf "${RED}Decryption failed!${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to encrypt a file with a GPG key
encrypt_file_gpg() {
    printf "${CYAN}Encrypting file with GPG key...${RESET}\n"
    printf "${YELLOW}Available public keys:${RESET}\n"
    gpg --list-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the recipient's key ID or email: ${RESET}"
    read recipient
    printf "${YELLOW}Enter the path to the file to encrypt: ${RESET}"
    read input_file
    if [ ! -f "$input_file" ]; then
        printf "${RED}File not found: $input_file${RESET}\n"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    printf "${YELLOW}Enter the output file path (default: ${input_file}.gpg): ${RESET}"
    read output_file
    if [ -z "$output_file" ]; then
        output_file="${input_file}.gpg"
    fi
    gpg --trust-model always --armor --encrypt --recipient "$recipient" --output "$output_file" "$input_file"
    if [ $? -eq 0 ]; then
        printf "${GREEN}File encrypted successfully to: $output_file${RESET}\n"
    else
        printf "${RED}Encryption failed!${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to decrypt a file with a GPG key
decrypt_file_gpg() {
    printf "${CYAN}Decrypting file with GPG key...${RESET}\n"
    printf "${YELLOW}Enter the path to the encrypted file: ${RESET}"
    read input_file
    if [ ! -f "$input_file" ]; then
        printf "${RED}File not found: $input_file${RESET}\n"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    printf "${YELLOW}Enter the output file path (default: ${input_file%.gpg}): ${RESET}"
    read output_file
    if [ -z "$output_file" ]; then
        output_file="${input_file%.gpg}"
        if [ "$output_file" = "$input_file" ]; then
            output_file="${input_file}.decrypted"
        fi
    fi
    gpg --decrypt --output "$output_file" "$input_file"
    if [ $? -eq 0 ]; then
        printf "${GREEN}File decrypted successfully to: $output_file${RESET}\n"
    else
        printf "${RED}Decryption failed!${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to sign a file with a GPG key
sign_file_gpg() {
    printf "${CYAN}Signing file with GPG key...${RESET}\n"
    printf "${YELLOW}Available private keys:${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to sign with: ${RESET}"
    read key_id
    printf "${YELLOW}Enter the path to the file to sign: ${RESET}"
    read input_file
    if [ ! -f "$input_file" ]; then
        printf "${RED}File not found: $input_file${RESET}\n"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    printf "${YELLOW}Enter the output signature file path (default: ${input_file}.sig): ${RESET}"
    read output_file
    if [ -z "$output_file" ]; then
        output_file="${input_file}.sig"
    fi
    gpg --default-key "$key_id" --armor --detach-sign --output "$output_file" "$input_file"
    if [ $? -eq 0 ]; then
        printf "${GREEN}File signed successfully. Signature saved to: $output_file${RESET}\n"
    else
        printf "${RED}Signing failed!${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to verify a signed file with a GPG key
verify_file_gpg() {
    printf "${CYAN}Verifying signed file...${RESET}\n"
    printf "${YELLOW}Enter the path to the original file: ${RESET}"
    read input_file
    if [ ! -f "$input_file" ]; then
        printf "${RED}File not found: $input_file${RESET}\n"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    printf "${YELLOW}Enter the path to the signature file (default: ${input_file}.sig): ${RESET}"
    read signature_file
    if [ -z "$signature_file" ]; then
        signature_file="${input_file}.sig"
    fi
    if [ ! -f "$signature_file" ]; then
        printf "${RED}Signature file not found: $signature_file${RESET}\n"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    printf "${CYAN}Verifying signature...${RESET}\n"
    if gpg --verify "$signature_file" "$input_file"; then
        printf "${GREEN}Signature verification successful!${RESET}\n"
    else
        printf "${RED}Signature verification failed!${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
}

# Function to clearsign a file with a GPG key
clearsign_file_gpg() {
    printf "${CYAN}Clearsigning file with GPG key...${RESET}\n"
    printf "${YELLOW}Available private keys:${RESET}\n"
    gpg --list-secret-keys --keyid-format LONG
    printf "\n${YELLOW}Enter the key ID to sign with: ${RESET}"
    read key_id
    printf "${YELLOW}Enter the path to the file to clearsign: ${RESET}"
    read input_file
    if [ ! -f "$input_file" ]; then
        printf "${RED}File not found: $input_file${RESET}\n"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    printf "${YELLOW}Enter the output file path (default: ${input_file}.asc): ${RESET}"
    read output_file
    if [ -z "$output_file" ]; then
        output_file="${input_file}.asc"
    fi
    gpg --default-key "$key_id" --armor --clearsign --output "$output_file" "$input_file"
    if [ $? -eq 0 ]; then
        printf "${GREEN}File clearsigned successfully to: $output_file${RESET}\n"
    else
        printf "${RED}Clearsigning failed!${RESET}\n"
    fi
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/gpg.sh
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
printf "${CYAN}4. Encryption & Decryption${RESET}\n"
printf "${GREEN}    41) Encrypt file with password (symmetric)${RESET}\n"
printf "${GREEN}    42) Decrypt file with password (symmetric)${RESET}\n"
printf "${GREEN}    43) Encrypt file with GPG key${RESET}\n"
printf "${GREEN}    44) Decrypt file with GPG key${RESET}\n"
printf "${CYAN}5. Digital Signatures${RESET}\n"
printf "${GREEN}    51) Sign file with GPG key${RESET}\n"
printf "${GREEN}    52) Verify signed file${RESET}\n"
printf "${GREEN}    53) Clearsign file with GPG key${RESET}\n"
printf "${CYAN}6. Exit${RESET}\n"
printf "${GREEN}    61) Exit${RESET}\n"
printf "${GREEN}    62) Return to main menu${RESET}\n"

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
    41) encrypt_file_password;;
    42) decrypt_file_password;;
    43) encrypt_file_gpg;;
    44) decrypt_file_gpg;;
    51) sign_file_gpg;;
    52) verify_file_gpg;;
    53) clearsign_file_gpg;;
    61) exit;;
    62) source $HOME/.archconfig/main.sh;;
    *) printf "${RED}Invalid choice. Please try again.${RESET}\n";;
esac