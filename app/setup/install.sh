#!/bin/bash

# install.sh - Script to install cli.sh as a command accessible within the user scope

SCRIPT_DIR=$(dirname "$(realpath "$0")") # This gets the directory of the current script (install.sh)
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")      # Move up one level to 'app'
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")      # Move up another level to the root directory

echo "INSTALL: Checking .env in directory: $SCRIPT_DIR"

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

CLI_PATH="$SCRIPT_DIR/app/cli.sh"
BIN_DIR="$HOME/.local/bin"
LINK_NAME="$BIN_DIR/$COMMAND_NAME"

mkdir -p "$BIN_DIR"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "Adding $BIN_DIR to PATH..."
    for file in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$file" ]; then
            echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$file"
        fi
    done
    export PATH="$BIN_DIR:$PATH"
    echo "Directory $BIN_DIR added to PATH."
fi


if [ -f "$CLI_PATH" ]; then
    if ln -s "$CLI_PATH" "$LINK_NAME"; then
        echo "Successfully linked $CLI_PATH to $LINK_NAME"
        echo "You can now use '$COMMAND_NAME' command within your user environment."
    else
        echo "Failed to create a symbolic link."
    fi
else
    echo "Script not found at $CLI_PATH"
fi
