#!/bin/bash
# server.sh - Script to handle server management commands with variable parameters.

# Default values
instance_size="l"
instance_count=1
cloud_provider="gcp"
git_repository=""
git_branch=""
uuid=$(uuidgen)

# Usage function for displaying help
usage() {
    echo "Usage:"
    echo "  mg server create [-size instance_size] [-count instance_count] [--cloud cloud_provider] [-repo git_repository] [-branch git_branch]"
    echo "  mg server destroy -id UUID"
    echo "  mg server show -id UUID"
    echo "  mg server help"
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
            --cloud)
                if [[ "$2" == "aws" || "$2" == "gcp" || "$2" == "azure" ]]; then
                    cloud_provider="$2"; shift 2;
                else
                    echo "Error: Unsupported cloud provider '$2'"
                    usage
                fi
                ;;
            -repo)
                git_repository="$2"; shift 2;;
            -branch)
                git_branch="$2"; shift 2;;
            -id)
                uuid="$2"; shift 2;;
            *)
                echo "Error: Invalid or unexpected option '$1'"
                usage
                ;;
        esac
    done
}

apply_server_module() {
    SCRIPT_DIR=$(dirname "$(realpath "$0")")
    source "$SCRIPT_DIR/terraform.sh"

    # Generate a UUID and set as an environment variable
    export TF_VAR_uuid="$uuid"

    # Setup other environment variables for Terraform
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

create_server() {
    echo "Starting server setup with the following parameters:"
    echo "Instance Size: $instance_size"
    echo "Instance Count: $instance_count"
    echo "Cloud Provider: $cloud_provider"
    echo "Environment ID: $uuid"
    if [[ -n "$git_repository" ]]; then
        echo "Repository: $git_repository"
    fi
    if [[ -n "$git_branch" ]]; then
        echo "Branch: $git_branch"
    fi

    #    apply_server_module
}

destroy_server() {
    echo "Destroying environment with ID: $uuid"
    # Add your logic to destroy the server
}

show_inventory() {
    echo "Displaying ansible inventory for server with ID: $uuid"
    # Add your logic to fetch and display ansible inventory
}

server() {
    case "$1" in
        create|destroy)
            command=$1
            shift  # Remove the command from the arguments list
            set_param "$@"
            "${command}_server"
            ;;
        show)
            shift  # Remove 'show' from the arguments list
            set_param "$@"
            show_inventory
            ;;
        help)
            usage
            ;;
        *)
            echo "Error: Invalid command or parameters."
            usage
            ;;
    esac
}

# Ensure that the script is not sourced but executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    server "$@"
fi


