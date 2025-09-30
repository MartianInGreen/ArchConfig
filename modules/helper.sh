#! /bin/bash

# Function to enable Nvidia GPU hotplugging
hotplug_nvidia() {
    printf "${CYAN}Please ensure no process is running on the GPU...${RESET}\n"
    nvidia-smi
    printf "${YELLOW}Are all processes stopped? (y/n): ${RESET}"
    read all_processes_stopped
    if [ "$all_processes_stopped" == "y" ]; then
        printf "${GREEN}All processes stopped, continuing...${RESET}\n"
        sudo rmmod nvidia_uvm
        sudo rmmod nvidia_drm
        sudo rmmod nvidia_modeset
        sudo rmmod nvidia

        sudo modprobe nvidia-drm
        source $HOME/.archconfig/modules/helper.sh
    else
        printf "${RED}Please ensure no process is running on the GPU...${RESET}\n"
        exit 1
    fi
}

# Rebuild KDE xdg cache
# Related: https://github.com/prasanthrangan/hyprdots/issues/1406
rebuild_kde_xdg_cache() {
    printf "${CYAN}Rebuilding KDE xdg cache...${RESET}\n"
    sudo pacman -S archlinux-xdg-menu
    XDG_MENU_PREFIX=arch- kbuildsycoca6
    printf "${GREEN}KDE xdg cache rebuilt successfully!${RESET}\n"
    read -n 1 -s -r -p "Press any key to continue..."
    # Source itself to get back to the main menu
    source $HOME/.archconfig/modules/helper.sh
}