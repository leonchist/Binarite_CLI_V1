#!/bin/bash

# uninstall.sh - Script to remove cli.sh as a user-scoped command

SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")

echo "UNINSTALL: Checking .env in directory: $SCRIPT_DIR"

# Load .env file
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(cat "$SCRIPT_DIR/.env" | xargs)
    echo ".env loaded successfully."
else
    echo ".env file not found in $SCRIPT_DIR"
    exit 1
fi

# Define the link path using the home directory
BIN_DIR="$HOME/.local/bin"
LINK_NAME="$BIN_DIR/mg"

echo "Attempting to remove symbolic link at: $LINK_NAME"

# Check if the symbolic link exists and remove it
if [ -L "$LINK_NAME" ]; then
    echo "Removing symbolic link for 'mg'..."
    if rm "$LINK_NAME"; then
        echo "Successfully removed 'mg'."
    else
        echo "Failed to remove symbolic link."
        exit 1
    fi
else
    echo "Symbolic link for 'mg' not found."
fi
