#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# Backup setup
backup_setup() {
    printf "${CYAN}Running backup setup...${RESET}\n"

    # Installing necessary packages
    printf "${YELLOW}Installing necessary packages...${RESET}\n"
    sudo pacman -S git cronie --noconfirm

    # Init git repo in the BACKUPS_PATH directory (if repo doesn't already exist)
    if [ ! -d $BACKUPS_PATH/.git ]; then
        git init $BACKUPS_PATH
    fi

    # Ask user if they want to add a cron job to run the backup every day at 20:00 
    printf "${YELLOW}Do you want to add a cron job to run the backup every day at 20:00? (y/n): ${RESET}"
    read add_cron
    if [ "$add_cron" == "y" ]; then
        (crontab -l 2>/dev/null; echo "0 20 * * * archconfig auto-backup") | crontab -
    fi
    
    printf "${GREEN}Backup setup complete!${RESET}\n"
}

# Create backup
create_backup() {
    printf "${CYAN}Creating backup...${RESET}\n"

    # Create backup directory
    printf "${YELLOW}Creating backup directory...${RESET}\n"
    mkdir -p $BACKUPS_PATH/$(date +%Y-%m-%d)
    touch $BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt

    # Backup files and directories
    printf "${YELLOW}Backing up files and directories...${RESET}\n"
    
    # Create necessary subdirectories for keys
    mkdir -p "$BACKUPS_PATH/$(date +%Y-%m-%d)/GPG"
    mkdir -p "$BACKUPS_PATH/$(date +%Y-%m-%d)/SSH"
    mkdir -p "$BACKUPS_PATH/$(date +%Y-%m-%d)/FILES"
    mkdir -p "$BACKUPS_PATH/$(date +%Y-%m-%d)/DIRS"
    mkdir -p "$BACKUPS_PATH/$(date +%Y-%m-%d)/FILES/ENCRYPTED"
    mkdir -p "$BACKUPS_PATH/$(date +%Y-%m-%d)/DIRS/ENCRYPTED"
    mkdir -p "$BACKUPS_PATH/$(date +%Y-%m-%d)/PACKAGES"
    
    # Backup individual files (preserving directory structure)
    for file in "${BACKUP_FILES[@]}"; do
        if [ -f "$file" ]; then
            # Create the full directory structure in backup
            backup_file_path="$BACKUPS_PATH/$(date +%Y-%m-%d)/FILES$file"
            backup_dir=$(dirname "$backup_file_path")
            mkdir -p "$backup_dir"
            
            cp "$file" "$backup_file_path"
            echo "Copied $file to $backup_file_path" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        else
            echo "Warning: File $file not found, skipping..." >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        fi
    done
    
    # Backup directories (preserving directory structure)
    for dir in "${BACKUP_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            # Create the full directory structure in backup
            backup_dir_path="$BACKUPS_PATH/$(date +%Y-%m-%d)/DIRS$dir"
            backup_parent_dir=$(dirname "$backup_dir_path")
            mkdir -p "$backup_parent_dir"
            
            cp -r "$dir" "$backup_dir_path"
            echo "Copied $dir to $backup_dir_path" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        else
            echo "Warning: Directory $dir not found, skipping..." >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        fi
    done

    # Backup encrypted individual files (preserving directory structure)
    for file in "${BACKUP_FILES_ENCRYPTED[@]}"; do
        if [ -f "$file" ]; then
            backup_file_path="$BACKUPS_PATH/$(date +%Y-%m-%d)/FILES/ENCRYPTED$file"
            backup_dir=$(dirname "$backup_file_path")
            mkdir -p "$backup_dir"
            cp "$file" "$backup_file_path"
            echo "Copied $file to $backup_file_path" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        else
            echo "Warning: File $file not found, skipping..." >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        fi
    done

    # Backup encrypted directories (preserving directory structure)
    for dir in "${BACKUP_DIRS_ENCRYPTED[@]}"; do
        if [ -d "$dir" ]; then
            backup_dir_path="$BACKUPS_PATH/$(date +%Y-%m-%d)/DIRS/ENCRYPTED$dir"
            backup_parent_dir=$(dirname "$backup_dir_path")
            mkdir -p "$backup_parent_dir"
            cp -r "$dir" "$backup_dir_path"
            echo "Copied $dir to $backup_dir_path" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        else
            echo "Warning: Directory $dir not found, skipping..." >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        fi
    done

    # Backup GPG and SSH keys
    printf "${MAGENTA}Backing up GPG and SSH keys...${RESET}\n"
    
    # Backup GPG keys
    if [ ${#BACKUP_GPG_KEY_IDS[@]} -gt 0 ]; then
        for gpg_key_id in "${BACKUP_GPG_KEY_IDS[@]}"; do
            gpg --export "$gpg_key_id" > "$BACKUPS_PATH/$(date +%Y-%m-%d)/GPG/GPG_KEY_$gpg_key_id.gpg"
            gpg --export-secret-keys "$gpg_key_id" > "$BACKUPS_PATH/$(date +%Y-%m-%d)/GPG/GPG_KEY_$gpg_key_id.secret.gpg"
            echo "Copied GPG key $gpg_key_id to $BACKUPS_PATH/$(date +%Y-%m-%d)/GPG/GPG_KEY_$gpg_key_id.gpg" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
        done
    else
        echo "No GPG keys configured for backup" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
    fi
    
    # Backup SSH keys
    if [ ${#BACKUP_SSH_KEY_IDS[@]} -gt 0 ]; then
        for ssh_key_path in "${BACKUP_SSH_KEY_IDS[@]}"; do
            if [ -f "$ssh_key_path" ]; then
                key_name=$(basename "$ssh_key_path")
                cp "$ssh_key_path" "$BACKUPS_PATH/$(date +%Y-%m-%d)/SSH/SSH_KEY_$key_name"
                ssh-keygen -y -f "$ssh_key_path" > "$BACKUPS_PATH/$(date +%Y-%m-%d)/SSH/SSH_KEY_$key_name.pub" 2>/dev/null || echo "Could not extract public key from $ssh_key_path" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
                echo "Copied SSH key $ssh_key_path to $BACKUPS_PATH/$(date +%Y-%m-%d)/SSH/SSH_KEY_$key_name" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
            else
                echo "Warning: SSH key $ssh_key_path not found, skipping..." >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
            fi
        done
    else
        echo "No SSH keys configured for backup" >> "$BACKUPS_PATH/$(date +%Y-%m-%d)/LOG.txt"
    fi

    # Set backup date variable for later use
    backup_date=$(date +%Y-%m-%d)
    
    # Check if there are any encrypted files or directories to backup
    encrypted_content_exists=false
    if [ -d "$BACKUPS_PATH/$backup_date/FILES/ENCRYPTED" ] && [ "$(ls -A "$BACKUPS_PATH/$backup_date/FILES/ENCRYPTED" 2>/dev/null)" ]; then
        encrypted_content_exists=true
    fi
    if [ -d "$BACKUPS_PATH/$backup_date/DIRS/ENCRYPTED" ] && [ "$(ls -A "$BACKUPS_PATH/$backup_date/DIRS/ENCRYPTED" 2>/dev/null)" ]; then
        encrypted_content_exists=true
    fi
    
    # Only encrypt if there's content to encrypt
    if [ "$encrypted_content_exists" = true ]; then
        # First TAR the ENCRYPTED files and directories (only if they have content)
        tar_files=""
        if [ -d "$BACKUPS_PATH/$backup_date/FILES/ENCRYPTED" ] && [ "$(ls -A "$BACKUPS_PATH/$backup_date/FILES/ENCRYPTED" 2>/dev/null)" ]; then
            tar_files="$tar_files $BACKUPS_PATH/$backup_date/FILES/ENCRYPTED"
        fi
        if [ -d "$BACKUPS_PATH/$backup_date/DIRS/ENCRYPTED" ] && [ "$(ls -A "$BACKUPS_PATH/$backup_date/DIRS/ENCRYPTED" 2>/dev/null)" ]; then
            tar_files="$tar_files $BACKUPS_PATH/$backup_date/DIRS/ENCRYPTED"
        fi
        
        if [ -n "$tar_files" ]; then
            printf "${YELLOW}Creating encrypted archive...${RESET}\n"
            tar -czf "$BACKUPS_PATH/$backup_date/ENCRYPTED.tar.gz" $tar_files
            echo "TARed $BACKUPS_PATH/$backup_date/ENCRYPTED.tar.gz" >> "$BACKUPS_PATH/$backup_date/LOG.txt"
            
            # Now get the password for encryption
            printf "${YELLOW}Enter the password to encrypt the backup: ${RESET}"
            read -s password
            printf "\n"
            
            # Then encrypt the TAR file using symmetric encryption with password
            printf "${YELLOW}Encrypting backup...${RESET}\n"
            gpg --batch --yes --passphrase "$password" --symmetric --cipher-algo AES256 "$BACKUPS_PATH/$backup_date/ENCRYPTED.tar.gz"
            if [ $? -eq 0 ] && [ -f "$BACKUPS_PATH/$backup_date/ENCRYPTED.tar.gz.gpg" ]; then
                echo "Encrypted $BACKUPS_PATH/$backup_date/ENCRYPTED.tar.gz" >> "$BACKUPS_PATH/$backup_date/LOG.txt"
                # Delete the unencrypted TAR file only if encryption succeeded and .gpg file exists
                rm "$BACKUPS_PATH/$backup_date/ENCRYPTED.tar.gz"
                echo "Deleted unencrypted TAR file" >> "$BACKUPS_PATH/$backup_date/LOG.txt"
                printf "${GREEN}Encryption completed successfully! Encrypted file: ENCRYPTED.tar.gz.gpg${RESET}\n"
            else
                printf "${RED}Encryption failed or encrypted file not created!${RESET}\n"
                echo "Encryption failed or encrypted file not created" >> "$BACKUPS_PATH/$backup_date/LOG.txt"
                if [ -f "$BACKUPS_PATH/$backup_date/ENCRYPTED.tar.gz" ]; then
                    printf "${YELLOW}Warning: Unencrypted TAR file still exists at $BACKUPS_PATH/$backup_date/ENCRYPTED.tar.gz${RESET}\n"
                fi
            fi
            
            # Then delete unencrypted files and directories
            rm -rf "$BACKUPS_PATH/$backup_date/FILES/ENCRYPTED" "$BACKUPS_PATH/$backup_date/DIRS/ENCRYPTED"
            echo "Deleted unencrypted files and directories" >> "$BACKUPS_PATH/$backup_date/LOG.txt"
        fi
    else
        echo "No encrypted content to process" >> "$BACKUPS_PATH/$backup_date/LOG.txt"
    fi

    # Backup packages
    printf "${YELLOW}Backing up packages...${RESET}\n"
    pacman -Qq > "$BACKUPS_PATH/$backup_date/PACKAGES/PACKAGES_PACMAN.txt"
    flatpak list --user > "$BACKUPS_PATH/$backup_date/PACKAGES/PACKAGES_FLATPAK.txt"
    echo "Backed up packages to $BACKUPS_PATH/$backup_date/PACKAGES/PACKAGES.txt" >> "$BACKUPS_PATH/$backup_date/LOG.txt"

    # Git add, commit and push the backup
    printf "${YELLOW}Git adding, committing and pushing the backup...${RESET}\n"
    cd $BACKUPS_PATH
    
    # Check if encrypted file exists
    if [ -f "$backup_date/ENCRYPTED.tar.gz.gpg" ]; then
        # Add the backup directory with encrypted content
        git add "$backup_date/"
        git commit -m "Encrypted backup created on $backup_date" --no-gpg-sign
    else
        # Add the unencrypted backup directory
        git add "$backup_date/"
        git commit -m "Backup created on $backup_date" --no-gpg-sign
    fi
    
    # Only push if we have a remote configured
    if git remote get-url origin >/dev/null 2>&1; then
        git push
    else
        echo "No git remote configured, skipping push" >> "$backup_date/LOG.txt"
    fi

    printf "${GREEN}Backup created successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Restore backup
restore_backup() {
    printf "${CYAN}Restoring backup...${RESET}\n"
    
    # Restore files and directories
    printf "${YELLOW}Restoring files and directories...${RESET}\n"

    # Restore GPG and SSH keys
    printf "${YELLOW}Restoring GPG and SSH keys...${RESET}\n"

}

# Main menu loop
printf "${CYAN}Backup module${RESET}\n"
printf "${YELLOW}Select an option:${RESET}\n\n"
printf "${CYAN}1. Backup Setup${RESET}\n"
printf "${GREEN}    10) Run backup setup${RESET}\n"
printf "${CYAN}2. Backup${RESET}\n"
printf "${GREEN}    21) Create Backup${RESET}\n"
printf "${GREEN}    22) Restore Backup${RESET}\n"
printf "${CYAN}9. Exit${RESET}\n"
printf "${GREEN}    91) Exit${RESET}\n"

# Get the user's choice
printf "Enter your choice: "
read choice

# Process the user's choice
case $choice in
    10) backup_setup;;
    21) create_backup;;
    22) restore_backup;;
    91) exit;;
    *) printf "${RED}Invalid choice. Please try again.${RESET}\n";;
esac