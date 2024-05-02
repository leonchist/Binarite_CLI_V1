#!/bin/bash

# setup.sh - Script to automate setup tasks for the CLI tool

SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "SETUP: Checking .env in directory: $SCRIPT_DIR"

APP_DIR="$SCRIPT_DIR/app"
SETUP_DIR="$APP_DIR/setup"
ANSIBLE_ROLES_PATH="$SCRIPT_DIR/ansible/playbooks/roles"
ANSIBLE_ROLE_NAME="geerlingguy.docker"

echo "Setting executable permissions on scripts..."
chmod +x "$APP_DIR/cli.sh"
chmod +x "$APP_DIR/terraform.sh"
chmod +x "$APP_DIR/region.sh"
chmod +x "$APP_DIR/label.sh"
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

check_uuidgen_installed() {
    if ! command -v uuidgen &> /dev/null; then
        echo "uuidgen is not installed. Please install uuid-runtime package to continue using this setup."
        echo "You can install it using your package manager. For example, on Ubuntu, run: sudo apt-get install uuid-runtime"
        exit 1
    fi
    echo "uuidgen is installed."
}

check_ansible_installed() {
    if ! command -v ansible &> /dev/null; then
        echo "Ansible is not installed. Please install Ansible to continue."
        echo "Visit https://docs.ansible.com/ansible/latest/installation_guide/index.html for installation instructions."
        exit 1
    fi
    echo "Ansible is installed."
}

install_ansible_role() {
    echo "Installing Ansible role: $ANSIBLE_ROLE_NAME..."
    ansible-galaxy install "$ANSIBLE_ROLE_NAME" --roles-path "$ANSIBLE_ROLES_PATH"
    if [ $? -eq 0 ]; then
        echo "Ansible role installed successfully."
    else
        echo "Failed to install Ansible role. Check if Ansible is installed and try again."
        exit 1
    fi
}


# Check if prerequisites are installed
check_jq_installed
check_uuidgen_installed
check_ansible_installed
install_ansible_role

echo "Running setup script..."
"$SETUP_DIR/install.sh"

echo "Setup complete."
