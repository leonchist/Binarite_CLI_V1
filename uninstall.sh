#!/bin/bash

# uninstall.sh - Script to remove manager.sh as system-wide command

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

LINK_NAME="/usr/local/bin/$COMMAND_NAME"

if [ -L "$LINK_NAME" ]; then
    echo "Removing symbolic link for '$COMMAND_NAME'..."
    if sudo rm "$LINK_NAME"; then
        echo "Successfully removed '$COMMAND_NAME'."
    else
        echo "Failed to remove symbolic link."
    fi
else
    echo "Symbolic link for '$COMMAND_NAME' not found."
fi
