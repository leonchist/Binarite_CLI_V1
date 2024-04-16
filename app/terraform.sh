#!/bin/bash

# terraform.sh - Script to manage and orchestrate Terraform operations across various modules.
# This script provides functions to initialize, apply, and destroy Terraform configurations for predefined modules.
# It includes functionality to handle individual modules as well as bulk operations across all modules.

SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")

TERRAFORM_ENV_PATH="$SCRIPT_DIR/terraform/environment"
MODULES=("network" "quark" "lb" "bots" "agents" "elastic_ips" "forwarder")

get_module_path() {
    module_name="$1"
    echo "$TERRAFORM_ENV_PATH/$module_name"
}

is_valid_module() {
    local module_name="$1"
    for module in "${MODULES[@]}"; do
        if [[ "$module" == "$module_name" ]]; then
            return 0
        fi
    done
    echo "Invalid module name: '$module_name'. Valid options are: ${MODULES[*]}"
    return 1
}


apply_module_and_print_outputs() {
    module_name="$1"
    if ! is_valid_module "$module_name"; then
        return 1
    fi
    local module_path=$(get_module_path "$module_name")
    echo "Applying and getting outputs for Terraform module: $module_name"
    cd "$module_path" || exit
    terraform apply
    echo "Outputs for $module_name:"
    terraform output
}


terraform_init() {
    module_name="$1"
    if [ "$module_name" == "all" ]; then
        echo "Initializing all Terraform modules..."
        for module in "${MODULES[@]}"; do
            local module_path=$(get_module_path "$module")
            echo "Initializing Terraform for module: $module"
            cd "$module_path" || exit
            terraform init
        done
    else
        if ! is_valid_module "$module_name"; then
            return 1
        fi
        local module_path=$(get_module_path "$module_name")
        echo "Initializing Terraform for module: $module_name"
        cd "$module_path" || exit
        terraform init
    fi
}

apply_module() {
    module_name="$1"
    if ! is_valid_module "$module_name"; then
        return 1
    fi
    local module_path=$(get_module_path "$module_name")
    echo "Applying Terraform module: $module_name"
    cd "$module_path" || exit
    terraform apply
}

destroy_module() {
    module_name="$1"
    if ! is_valid_module "$module_name"; then
        return 1
    fi
    local module_path=$(get_module_path "$module_name")
    echo "Destroying Terraform module: $module_name"
    cd "$module_path" || exit
    terraform destroy
}

apply_all_modules() {
    for module_name in "${MODULES[@]}"; do
        apply_module "$module_name"
    done
}

destroy_all_modules() {
    for (( idx=${#MODULES[@]}-1 ; idx>=0 ; idx-- )); do
        destroy_module "${MODULES[idx]}"
    done
}
