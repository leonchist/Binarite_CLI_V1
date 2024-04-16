#!/bin/bash
# Function to destroy Terraform modules
destroy() {
    if [ "$1" == "all" ]; then
        destroy_all_modules
    else
        destroy_module "$1"
    fi
}
