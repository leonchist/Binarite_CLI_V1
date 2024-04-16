#!/bin/bash
# Function to handle creation of specific configurations
create() {
    if [ "$1" == "quark" ]; then
        apply_module_and_print_outputs "network"
        apply_module_and_print_outputs "quark"
    else
        echo "Unrecognized command. Did you mean 'create quark'?"
    fi
}
