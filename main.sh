#!/bin/bash

# Source the config file
source ~/.archconfig/config.sh

# Argument Parsing
# ------------------------------------------------------------
# -h, --help

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: archconfig [command]"
    echo "Commands:"
    echo "  update     Update the ArchConfig application"
    echo "  help       Show this help message"
    exit 0
fi

# Update the ArchConfig repository
if [ "$1" == "update" ]; then
    source ~/.archconfig/modules/update.sh
    exit 0
fi

