#!/bin/bash
# Function to list all environments
list_envs() {
    echo "List of all environments in the inventory:"
    cat "${TERRAFORM_ENV_PATH}/../ansible/inventory/hosts.cfg"
}
