#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
TERRAFORM_ENV_PATH="$SCRIPT_DIR/terraform/environment"
MODULES=("network" "quark" "lb" "bots" "agents" "elastic_ips" "forwarder")

# Load .env from script's directory
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(cat "$SCRIPT_DIR/.env" | xargs)
else
    echo ".env file not found in $SCRIPT_DIR"
    exit 1
fi

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

run_ansible() {
    playbook_path="$1"
    echo "Running Ansible playbook: $playbook_path"
    ansible-playbook "$playbook_path"
}

case $1 in
    init)
        terraform_init "$2"
        ;;
    apply)
        if [ "$2" == "all" ]; then
            apply_all_modules
        else
            apply_module "$2"
        fi
        ;;
    destroy)
        if [ "$2" == "all" ]; then
            destroy_all_modules
        else
            destroy_module "$2"
        fi
        ;;
    create)
        if [ "$2" == "quark" ]; then
            apply_module_and_print_outputs "network"
            apply_module_and_print_outputs "quark"
        else
            echo "Unrecognized command. Did you mean 'create quark'?"
        fi
        ;;
    help)
        echo "Usage: $0 COMMAND [MODULE_NAME]"
        echo ""
        echo "Commands:"
        echo "  init [module_name|all]  - Initialize Terraform modules."
        echo "  apply [module_name|all] - Apply Terraform modules."
        echo "  destroy [module_name|all] - Destroy Terraform modules."
        echo "  create quark - Apply 'network' and 'quark' modules and print outputs."
        echo "  help - Display this help."
        echo ""
        echo "Available Modules: ${MODULES[*]}"
        ;;
    *)
        echo "Invalid command. For a list of commands, run: $0 help"
        ;;
esac
