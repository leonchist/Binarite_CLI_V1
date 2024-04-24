#!/bin/bash
# server.sh - Script to handle server creation command with variable parameters.

# Default values
instance_size="M"
instance_count=1
git_repository=""
git_branch=""

# Usage function for displaying help
usage() {
    echo "Usage: $0 server [-size instance_size] [-count instance_count] [-repo git_repository] [-branch git_branch]"
    exit 1
}

# Set parameters based on the command line arguments
set_param() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -size)
                instance_size="$2"; shift 2;;
            -count)
                instance_count="$2"; shift 2;;
            -repo)
                git_repository="$2"; shift 2;;
            -branch)
                git_branch="$2"; shift 2;;
            -*)
                echo "Error: Invalid option '$1'"
                usage
                ;;
            *)
                echo "Error: Unexpected parameter '$1'"
                usage
                ;;
        esac
    done
}

server() {
    # Check for parameters
    if [[ "$#" -eq 0 ]]; then
        echo "No parameters specified. Using default values."
    else
        set_param "$@"
    fi

    echo "Starting server setup with the following parameters:"
    echo "Instance Size: $instance_size"
    echo "Instance Count: $instance_count"
    if [[ -n "$git_repository" ]]; then
        echo "Repository: $git_repository"
    fi
    if [[ -n "$git_branch" ]]; then
        echo "Branch: $git_branch"
    fi
    # Function to apply the Terraform module with the specified parameters
    # apply_server_module # uncomment for terraform integration
}

# Function to apply the Terraform module with the specified parameters
apply_server_module() {
    SCRIPT_DIR=$(dirname "$(realpath "$0")")
    source "$SCRIPT_DIR/terraform.sh"

    # Setup environment variables for Terraform
    export TF_VAR_instance_size="$instance_size"
    export TF_VAR_instance_count="$instance_count"
    export TF_VAR_git_repository="$git_repository"
    export TF_VAR_git_branch="$git_branch"

    # Assuming 'server' is a valid module within your Terraform setup
    if is_valid_module "server"; then
        local module_path=$(get_module_path "server")
        echo "Applying Terraform module: server"
        cd "$module_path" || exit
        terraform apply -auto-approve
    else
        echo "Error: Server module not found in Terraform configurations."
        exit 1
    fi
}

