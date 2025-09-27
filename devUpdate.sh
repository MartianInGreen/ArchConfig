#!/bin/bash

# Local update without git
wd=$(pwd)

# Move old config to ~/.tmp/archconfig
mkdir -p ~/.tmp/archconfig
mv ~/.archconfig/config.sh ~/.tmp/archconfig/config.sh


# Copy from the current directory to the ~/.archconfig/ dirs
rm -rf ~/.archconfig/modules/
rm -rf ~/.archconfig/config.sh
rm -rf ~/.archconfig/main.sh

cp -r $wd/modules/ ~/.archconfig/modules/
cp $wd/main.sh ~/.archconfig/main.sh

# Move back the old config
mv ~/.tmp/archconfig/config.sh ~/.archconfig/config.sh

# Make the main.sh executable
chmod +x ~/.archconfig/main.sh

# Print the message
printf "${GREEN}ArchConfig updated successfully${RESET}\n"
printf "You can now use the ${CYAN}archconfig${RESET} command to manage your Arch Linux configuration"
echo "To use the command, you need to add ~/.local/bin to your PATH"
echo "To add it to your PATH, run the following command:"
printf "${YELLOW}echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc${RESET}\n"
printf "${YELLOW}source ~/.bashrc${RESET}\n"