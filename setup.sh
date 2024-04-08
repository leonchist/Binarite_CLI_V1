#!/bin/bash

# setup.sh - Script to automate setup tasks for manager.sh and related scripts

SCRIPT_DIR=$(dirname "$(realpath "$0")")

echo "Setting executable permissions on scripts..."
chmod +x "$SCRIPT_DIR/manager.sh"
chmod +x "$SCRIPT_DIR/setup.sh"
chmod +x "$SCRIPT_DIR/uninstall.sh"
echo "Permissions set."

if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(cat "$SCRIPT_DIR/.env" | xargs)
else
    echo ".env file not found! Ensure .env is in the same directory as this script."
    exit 1
fi

if [ -z "$COMMAND_NAME" ]; then
    echo "COMMAND_NAME not defined in .env file!"
    exit 1
fi

echo "Running setup script..."
sudo "$SCRIPT_DIR/install.sh"

echo "Setup complete."
