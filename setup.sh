#!/bin/bash

# setup.sh - Script to automate setup tasks for the CLI tool

SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "SETUP: Checking .env in directory: $SCRIPT_DIR"

APP_DIR="$SCRIPT_DIR/app"
SETUP_DIR="$APP_DIR/setup"

echo "Setting executable permissions on scripts..."
chmod +x "$APP_DIR/cli.sh"
chmod +x "$APP_DIR/terraform.sh"
chmod +x "$APP_DIR/region.sh"
chmod +x "$SETUP_DIR/install.sh"
chmod +x "$SETUP_DIR/uninstall.sh"
find "$APP_DIR/methods" -type f -iname "*.sh" -exec chmod +x {} \;
echo "Permissions set."

if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(cat "$SCRIPT_DIR/.env" | xargs)
else
    echo ".env file not found! Ensure .env is in the same directory as this script."
    exit 1
fi

check_jq_installed() {
    if ! command -v jq &> /dev/null; then
        echo "jq is not installed. Please install jq to continue using this setup."
        echo "Visit https://stedolan.github.io/jq/download/ for installation instructions."
        exit 1
    fi
    echo "jq is installed."
}

# Check if jq is installed
check_jq_installed

echo "Running setup script..."
"$SETUP_DIR/install.sh"

echo "Setup complete."
