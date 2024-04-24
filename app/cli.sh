#!/bin/bash

# cli.sh - Command Line Interface script to manage various Terraform modules.
# This script acts as the main entry point for executing commands defined in the METHODS array.
# It handles environment variable loading, method script sourcing, and command execution.

SCRIPT_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath $SCRIPT_DIR/..)

if [ -f "$SCRIPT_DIR/../.env" ]; then
    export $(cat "$SCRIPT_DIR/../.env" | xargs)
else
    echo ".env file not found in $SCRIPT_DIR/../"
    exit 1
fi

source "$SCRIPT_DIR/terraform.sh"

METHODS=(server init apply destroy create list_envs destroy_env help)

function contains_element {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}


if contains_element "$1" "${METHODS[@]}"; then
    method=$1
    shift # remove the method name from the argument list
    source "$SCRIPT_DIR/app/methods/$method.sh"
    if declare -f $method > /dev/null; then
        # If the function exists, call it with all remaining arguments
        $method "$@"
    else
        echo "Error: $method is not a function or not defined in the sourced script."
        exit 1
    fi
else
    echo "Invalid command. For a list of commands, run: $0 help"
fi
