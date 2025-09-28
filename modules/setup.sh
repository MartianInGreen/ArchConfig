#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# ------------------------------------------------------------
# Setup Auth Methods
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# Setup System Configuration
# ------------------------------------------------------------

# ------------------------------------------------------------
# Setup Package Management
# ------------------------------------------------------------

install_yay() {
    printf "${CYAN}Installing yay...${RESET}\n"
    sudo pacman -S --needed git base-devel
    cd $HOME/Downloads
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    printf "${GREEN}yay installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_flatpak() {
    printf "${CYAN}Installing flatpak...${RESET}\n"
    yay -Syu flatpak --noconfirm
    printf "${GREEN}flatpak installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_docker() {
    printf "${CYAN}Installing docker...${RESET}\n"
    yay -Syu docker --noconfirm

    # Adding user to docker group
    sudo usermod -aG docker $USER

    # Starting docker service
    sudo systemctl start docker
    sudo systemctl enable docker

    printf "${GREEN}docker installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_virtualisation() {
    printf "${CYAN}Installing virtualisation...${RESET}\n"
    yay -Syu qemu virt-manager --noconfirm
    printf "${GREEN}virtualisation installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_gaming() {
    printf "${CYAN}Installing gaming...${RESET}\n"
    yay -Syu steam \
             prismlauncher --noconfirm
    printf "${GREEN}gaming installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_development() {
    printf "${CYAN}Installing development...${RESET}\n"
    yay -Syu cursor-bin \
             ttf-firacode-nerd \
             vim \
             git \
             zsh \
             tmux \
             fzf \
             eza \
             zoxide \
             code --noconfirm
    printf "${GREEN}development installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_media() {
    printf "${CYAN}Installing media...${RESET}\n"
    yay -Syu vlc \
             spotify --noconfirm
    printf "${GREEN}media installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_productivity() {
    printf "${CYAN}Installing productivity...${RESET}\n"
    yay -Syu libreoffice \
             zen-browser-bin --noconfirm
    printf "${GREEN}productivity installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_other() {
    printf "${CYAN}Installing other...${RESET}\n"
    yay -Syu fastfetch \
             --noconfirm
    printf "${GREEN}other installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_cosmic() {
    printf "${CYAN}Installing COSMIC...${RESET}\n"
    yay -Syu cosmic \ 
             cosmic-app-library \
             cosmic-applets \
             cosmic-bg \
             cosmic-comp \
             cosmic-ext-applet-emoji-selector-git \
             cosmic-ext-applet-emoji-selector-git-debug \
             cosmic-ext-applet-privacy-indicator \
             cosmic-ext-applet-privacy-indicator-debug \
             cosmic-ext-applet-sysinfo-git \
             cosmic-ext-applet-sysinfo-git-debug \
             cosmic-files \
             cosmic-greeter \
             cosmic-icon-theme \
             cosmic-idle \
             cosmic-launcher \
             cosmic-notifications \
             cosmic-osd \
             cosmic-panel \
             cosmic-randr \
             cosmic-screenshot \
             cosmic-session \
             cosmic-settings \
             cosmic-settings-daemon \
             cosmic-workspaces \
             gvfs \
             gvfs-dnssd \
             gvfs-smb \
             gvfs-nfs \
             satty \ 
             wl-clipboard \
             xdg-desktop-portal-cosmic --noconfirm

    # Replace Default greeter with cosmic greeter
    sudo systemctl disable lightdm.service
    sudo systemctl disable gdm.service
    sudo systemctl disable sddm.service
    sudo systemctl disable lxdm.service
    sudo systemctl enable cosmic-greeter.service

    printf "${GREEN}Cosmic installed successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# Main menu loop
# Print the options

printf "${CYAN}Setup module${RESET}\n"
printf "${YELLOW}Select an option:${RESET}\n\n"
printf "${CYAN}1. Setup Auth Methods${RESET}\n"
printf "${GREEN}    11) Setup fingerprint${RESET}\n"
printf "${CYAN}2. System Configuration${RESET}\n"
printf "${CYAN}3. Package Management${RESET}\n"
printf "${GREEN}    31) Install yay${RESET}\n"
printf "${GREEN}    32) Install flatpak${RESET}\n"
printf "${GREEN}    33) Install & Setup Docker${RESET}\n"
printf "${GREEN}    34) Install & Setup Virtualisation${RESET}\n"
printf "${GREEN}    35) Install & Setup Gaming${RESET}\n"
printf "${GREEN}    36) Install & Setup Development${RESET}\n"
printf "${GREEN}    37) Install & Setup Media${RESET}\n"
printf "${GREEN}    38) Install & Setup Productivity${RESET}\n"
printf "${GREEN}    39) Install & Setup Other${RESET}\n"
printf "${GREEN}    310) Install & Setup Cosmic${RESET}\n"
printf "${CYAN}9. Exit${RESET}\n"
printf "${GREEN}    91) Exit${RESET}\n"

# Get the user's choice
printf "Enter your choice: "
read choice

# Process the user's choice
case $choice in
    11) setup_fingerprint;;
    21) install_yay;;
    22) install_flatpak;;
    23) install_docker;;
    24) install_virtualisation;;
    25) install_gaming;;
    26) install_development;;
    27) install_media;;
    28) install_productivity;;
    29) install_other;;
    310) install_cosmic;;
    91) exit;;
    *) printf "${RED}Invalid choice. Please try again.${RESET}\n";;
esac