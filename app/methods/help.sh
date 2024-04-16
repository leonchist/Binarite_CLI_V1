#!/bin/bash
# Function to display help information
help() {
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
}
