#!/bin/bash
# server.sh - Script to handle server creation command with variable parameters.

# Default values
instance_size="l"
instance_count=1
git_repository=""
git_branch=""
provider="gcp"
region="europe-west1"
uuid=""

# Usage function for displaying help
usage() {
    echo "Usage: $0 server [-size instance_size] [-count instance_count] [-repo git_repository] [-branch git_branch] [-provider provider] [-region region]"
    exit 1
}

# Set parameters based on the command line arguments
set_param() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -destroy)
                uuid="$2"; shift 2;;
            -size)
                instance_size="$2"; shift 2;;
            -count)
                instance_count="$2"; shift 2;;
            -repo)
                git_repository="$2"; shift 2;;
            -branch)
                git_branch="$2"; shift 2;;
            -provider)
                provider="$2"; shift 2;;
            -region)
                region="$2"; shift 2;;
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
    apply_server_module # uncomment for terraform integration
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
    export TF_VAR_server_region="$region"

    if [[ -z "$uuid" ]]; then
        creation_mode=true
        uuid=$(uuid)
    fi
    work_dir="$HOME/.mg/$uuid"

    # Generate JSON using jq
    json=$(jq -n \
    --arg owner "$OWNER" \
    --arg project "$PROJECT" \
    --arg uuid "$uuid" \
    '{
        Owner: $owner,
        Project: $project,
        Uuid: $uuid,
        Env: "Dev",
        Role: "Cluster",
    }')
    export TF_VAR_metadata=$json
    export TF_VAR_ansible_inventory_path="$work_dir/ansible/inventory/hosts.ini"
    export TF_VAR_known_host_path=$work_dir/known_hosts

    export TF_IN_AUTOMATION=1
    export TF_DATA_DIR=$work_dir/.terraform
    tf_state=$work_dir/state/terraform.tfstate
    tf_conf="$ROOT_DIR/terraform/template/quark-single/$provider"

    export TF_VAR_public_key="$ROOT_DIR/gdc-infra.pub" # TODO generate from terrafotm
    export TF_VAR_private_key="$ROOT_DIR/gdc-infra" # TODO generate from terrafotm

    export ANSIBLE_CONFIG=$ROOT_DIR/ansible.cfg

    echo "Debug : Using tf configuration from : $tf_conf"
    echo "Debug : Setting tf state to : $tf_state"

    if [[ $creation_mode = true ]]; then
        create_server
    else
        destroy_server
    fi

    # # Assuming 'server' is a valid module within your Terraform setup
    # if is_valid_module "server"; then
    #     local module_path=$(get_module_path "server")
    #     echo "Applying Terraform module: server"
    #     cd "$module_path" || exit
    #     terraform apply -auto-approve
    # else
    #     echo "Error: Server module not found in Terraform configurations."
    #     exit 1
    # fi
}

create_server() {
    terraform -chdir="$tf_conf" init -input=false -backend-config="path=$tf_state"
    terraform -chdir="$tf_conf" plan -input=false
    terraform -chdir="$tf_conf" apply -input=false -auto-approve

    ansible all -m ping -i $TF_VAR_ansible_inventory_path

    while [[ $? -ne 0 ]]; do
        echo "waiting for nodes to come online"
        sleep 10
        ansible all -m ping -i $TF_VAR_ansible_inventory_path
    done

    ansible-playbook -i $TF_VAR_ansible_inventory_path ./ansible/playbooks/single_quark.yaml

    echo "new cluster uuid : $uuid"
    terraform -chdir="$tf_conf" output
}

destroy_server() {
    terraform -chdir="$tf_conf" destroy -input=false -auto-approve
}