#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# Update the ArchConfig repository
cd $GIT_PATH
git fetch 
git pull 

# Update the ArchConfig application
cp $GIT_PATH/main.sh $HOME/.archconfig/main.sh
cp -r $GIT_PATH/modules/ ~/.archconfig/

# Compare the config.sh file
if [ "$(diff $GIT_PATH/config.sh $HOME/.archconfig/config.sh)" ]; then
    printf "${YELLOW}Config file has changed, please review the changes and update the config file...${RESET}\n"
    diff $GIT_PATH/config.sh ~/.archconfig/config.sh
    printf "${YELLOW}Do you want to update the config file? ${RED}THIS WILL OVERWRITE THE CURRENT CONFIG FILE${RESET} (y/n)${RESET}\n"
    read -n 1 -r update_config
    update_config=$(echo "$update_config" | tr -d '\r')
    if [ "$update_config" == "y" ]; then
        cp $GIT_PATH/config.sh $HOME/.archconfig/config.sh
    fi
else
    printf "${GREEN}Config file is up to date${RESET}\n"
fi