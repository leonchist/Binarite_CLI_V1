#!/bin/bash
# Function to apply Terraform modules
apply() {
    if [ "$1" == "all" ]; then
        apply_all_modules
    else
        apply_module "$1"
    fi
}
