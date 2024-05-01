#!/bin/bash

# install.sh - Script to install cli.sh as a command accessible within the user scope

# Navigate up three levels from the current script location to get to the root directory
SCRIPT_DIR=$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")

echo "INSTALL: Checking .env in directory: $SCRIPT_DIR"

# Load the .env file if it exists, or exit with an error if it does not
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs) # Skip commented lines in .env file
    echo ".env loaded successfully."
else
    echo ".env file not found!"
    exit 1
fi

# Define the path to the CLI script and the link location within the user's local bin directory
CLI_PATH="$SCRIPT_DIR/app/cli.sh"
BIN_DIR="$HOME/.local/bin"
LINK_NAME="$BIN_DIR/mg"
echo "Script at $CLI_PATH"

# Ensure the binary directory exists
mkdir -p "$BIN_DIR"

# Install ansible dependencies
pushd "$SCRIPT_DIR"
ansible-galaxy install -r requirements.yml
popd

# Add the binary directory to PATH if it's not already included
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "Adding $BIN_DIR to the beginning of PATH..."
    echo "export PATH=\"$BIN_DIR:\$PATH\"" | cat - "$HOME/.profile" > temp && mv temp "$HOME/.profile"
    export PATH="$BIN_DIR:$PATH"
    echo "Directory $BIN_DIR added to the beginning of PATH. Please restart your terminal or source your profile to apply changes."
fi

# Create a symbolic link for the CLI command, if the script exists
if [ -f "$CLI_PATH" ]; then
    # Check if a link already exists and remove it
    [ -L "$LINK_NAME" ] && rm "$LINK_NAME"
    if ln -s "$CLI_PATH" "$LINK_NAME"; then
        echo "Successfully linked $CLI_PATH to $LINK_NAME"
        echo "You can now use the 'mg' command within your user environment."
    else
        echo "Failed to create a symbolic link."
        exit 1
    fi
else
    echo "Script not found at $CLI_PATH"
    exit 1
fi
