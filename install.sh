#!/bin/bash

# install.sh - Script to install manager.sh as system-wide command

SCRIPT_DIR=$(dirname "$(realpath "$0")")
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(cat "$SCRIPT_DIR/.env" | xargs)
else
    echo ".env file not found!"
    exit 1
fi

if [ -z "$COMMAND_NAME" ]; then
    echo "COMMAND_NAME not defined in .env file!"
    exit 1
fi

SCRIPT_PATH="$SCRIPT_DIR/manager.sh"
LINK_NAME="/usr/local/bin/$COMMAND_NAME"

# Create a symbolic link
if [ -f "$SCRIPT_PATH" ]; then
    if sudo ln -s "$SCRIPT_PATH" "$LINK_NAME"; then
        echo "Successfully linked $SCRIPT_PATH to $LINK_NAME"
        echo "You can now use '$COMMAND_NAME' command system-wide."
    else
        echo "Failed to create a symbolic link."
    fi
else
    echo "Script not found at $SCRIPT_PATH"
fi
