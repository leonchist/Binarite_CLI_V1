#!/bin/bash
# server.sh - Script to handle server management commands with variable parameters.

# Get paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Source regions
source "$SCRIPT_DIR/region.sh"

# Default values
instance_size="l"
instance_count=1
cloud_provider="gcp"
cloud_region="europe-west1"
git_repository=""
git_branch=""
uuid=$(uuidgen)
owner="get_from_github" # todo: get from github
project=""

# Usage function for displaying help
usage() {
    echo "Usage:"
    echo "  mg server create -project project_name [-size instance_size] [-count instance_count] [-cloud cloud_provider] [-repo git_repository] [-branch git_branch]  [-region region]"
    echo "  mg server destroy -id UUID"
    echo "  mg server show -id UUID"
    echo "  mg server help"
    exit 1
}

# Set parameters based on the command line arguments
set_param() {
    local project_set=false
    local require_project=true
    local command="$1"
    shift # remove the command from the parameters to process options

    if [[ "$command" == "show"  || "$command" == "destroy" ]]; then
        require_project=false
    fi

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -size)
                instance_size="$2"; shift 2;;
            -count)
                instance_count="$2"; shift 2;;
            -cloud)
                if [[ "$2" == "aws" || "$2" == "gcp" || "$2" == "azure" ]]; then
                    cloud_provider="$2"
                    regions=$(get_regions_for_provider "$cloud_provider")
                    cloud_region=$(echo "$regions" | awk '{print $1}')
                    shift 2
                else
                    echo "Error: Unsupported cloud provider '$2'"
                    usage
                fi
                ;;
            -region)
                region_option="$2"
                regions=$(get_regions_for_provider "$cloud_provider")
                if [[ $regions =~ (^|[[:space:]])$region_option($|[[:space:]]) ]]; then
                    cloud_region="$region_option"
                    shift 2
                else
                    echo "Error: Unsupported cloud_region '$region_option' for provider '$cloud_provider'"
                    usage
                fi
                ;;
            -repo)
                git_repository="$2"; shift 2;;
            -branch)
                git_branch="$2"; shift 2;;
            -id)
                uuid="$2"; shift 2;;
            -project)
                project="$2"; project_set=true; shift 2;;
            *)
                echo "Error: Invalid or unexpected option '$1'"
                usage
                ;;
        esac
    done

    if ! $project_set && $require_project; then
        echo "Error: Project name is required."
        usage
    fi
}

apply_server_module() {
    source "$SCRIPT_DIR/terraform.sh"

    # Setup work directory
    work_dir="$HOME/.mg/$uuid"
    mkdir -p "$work_dir"


    # Setup environment variables for Terraform
    export TF_VAR_uuid="$uuid"
    export TF_VAR_instance_size="$instance_size"
    export TF_VAR_instance_count="$instance_count"
    export TF_VAR_cloud_provider="$cloud_provider"
    export TF_VAR_cloud_region="$cloud_region"
    export TF_VAR_git_repository="$git_repository"
    export TF_VAR_git_branch="$git_branch"
    export TF_VAR_project="$project"

    export TF_VAR_ansible_inventory_path="$work_dir/ansible/inventory/hosts.ini"
    export TF_VAR_known_host_path="$work_dir/known_hosts"
    export TF_VAR_public_key="$ROOT_DIR/gdc-infra.pub"
    export TF_VAR_private_key="$ROOT_DIR/gdc-infra"
    export ANSIBLE_CONFIG="$ROOT_DIR/ansible.cfg"
    export TF_DATA_DIR="$work_dir/.terraform"
    export TF_IN_AUTOMATION=1

    tf_state=$work_dir/state/terraform.tfstate
    tf_conf="$ROOT_DIR/terraform/template/quark-single/$cloud_provider"

    # Generate JSON and save to file
    json_file="$work_dir/creation.json"
    jq -n \
      --arg owner "$owner" \
      --arg project "$project" \
      --arg uuid "$uuid" \
      '{
          Owner: $owner,
          Project: $project,
          Uuid: $uuid,
          Env: "Dev",
          Role: "Cluster"
      }' > "$json_file"


    # Save environment variables to metadata file
    meta_file="$work_dir/metadata"
    {
        echo "TF_VAR_uuid=$TF_VAR_uuid"
        echo "TF_VAR_instance_size=$TF_VAR_instance_size"
        echo "TF_VAR_instance_count=$TF_VAR_instance_count"
        echo "TF_VAR_cloud_provider=$TF_VAR_cloud_provider"
        echo "TF_VAR_cloud_region=$TF_VAR_cloud_region"
        echo "TF_VAR_git_repository=$TF_VAR_git_repository"
        echo "TF_VAR_git_branch=$TF_VAR_git_branch"
        echo "TF_VAR_project=$TF_VAR_project"
        echo "TF_VAR_ansible_inventory_path=$TF_VAR_ansible_inventory_path"
        echo "TF_VAR_known_host_path=$TF_VAR_known_host_path"
        echo "TF_VAR_public_key=$TF_VAR_public_key"
        echo "TF_VAR_private_key=$TF_VAR_private_key"
        echo "ANSIBLE_CONFIG=$ANSIBLE_CONFIG"
        echo "TF_DATA_DIR=$TF_DATA_DIR"
        echo "TF_IN_AUTOMATION=$TF_IN_AUTOMATION"
        echo "tf_state=$tf_state"
        echo "tf_conf=$tf_conf"
        echo "JSON_Creation_File=$json_file"
    } > "$meta_file"

    echo "Debug : Using tf configuration from : $tf_conf"
    echo "Debug : Setting tf state to : $tf_state"
    echo "Debug : Creation file : $json_file"
    echo "Debug : Metadata file : $meta_file"

    terraform -chdir="$tf_conf" init -input=false -backend-config="path=$tf_state"
    terraform -chdir="$tf_conf" plan -input=false -var "environment=$json_file"
    terraform -chdir="$tf_conf" apply -input=false -auto-approve -var "environment=$json_file"
    ansible all -m ping -i $TF_VAR_ansible_inventory_path
    while [[ $? -ne 0 ]]; do
        echo "waiting for nodes to come online"
        sleep 10
        ansible all -m ping -i $TF_VAR_ansible_inventory_path
    done
    ansible-playbook -i $TF_VAR_ansible_inventory_path $ROOT_DIR/ansible/playbooks/single_quark.yaml
    terraform -chdir="$tf_conf" output public_ips
}

create_server() {
    echo "Starting server setup with the following parameters:"
    echo "Project Name: $project"
    echo "Instance Size: $instance_size"
    echo "Instance Count: $instance_count"
    echo "Cloud Provider: $cloud_provider"
    echo "Cloud Region: $cloud_region"
    echo "Environment ID: $uuid"
    if [[ -n "$git_repository" ]]; then
        echo "Repository: $git_repository"
    fi
    if [[ -n "$git_branch" ]]; then
        echo "Branch: $git_branch"
    fi

    apply_server_module
}

destroy_server() {
    if [[ -z "$uuid" ]]; then
        echo "Error: UUID is required."
        return
    fi

    local base_dir="$HOME/.mg/$uuid"
    local meta_file="$base_dir/metadata"

    if [[ -f "$meta_file" ]]; then
        source "$meta_file"
    else
        echo "Error: Metadata file does not exist for this UUID at expected path: $meta_file"
        return
    fi

    local tf_conf="$ROOT_DIR/terraform/template/quark-single/$TF_VAR_cloud_provider"
    local state_file="$base_dir/state/terraform.tfstate"
    local json_file="$base_dir/creation.json"

    # Check if the configuration directory exists before proceeding
    if [[ -d "$tf_conf" ]]; then
        # Initialize Terraform with the specific state file and reconfigure
        terraform -chdir="$tf_conf" init -input=false -reconfigure -backend-config="path=$state_file"

        # Now run destroy with the required variables
        terraform -chdir="$tf_conf" destroy -input=false -auto-approve \
            -var "cloud_region=$TF_VAR_cloud_region" \
            -var "ansible_inventory_path=$TF_VAR_ansible_inventory_path" \
            -var "public_key=$TF_VAR_public_key" \
            -var "private_key=$TF_VAR_private_key" \
            -var "known_host_path=$TF_VAR_known_host_path" \
            -var "environment=$json_file"
    else
        echo "Error: Terraform configuration directory does not exist: $tf_conf"
        return
    fi
}

show_inventory() {
    if [[ -z "$uuid" ]]; then
        echo "Error: UUID is required."
        usage
        return
    fi

    local base_dir="$HOME/.mg/$uuid"
    local inventory_file_path="$base_dir/ansible/inventory/hosts.ini"

    if [[ -f "$inventory_file_path" ]]; then
        echo "Displaying ansible inventory for environment ID $uuid:"

        # Extract Quark and Grafana IP addresses
        local quark_ip=$(grep -A 1 '\[quark_servers\]' "$inventory_file_path" | tail -n 1)
        local grafana_ip=$(grep -A 1 '\[grafana\]' "$inventory_file_path" | tail -n 1)

        echo "Quark Server IP: $quark_ip"
        echo "Grafana IP: $grafana_ip"
    else
        echo "Error: Inventory file does not exist for this UUID at expected path: $inventory_file_path"
    fi
}


server() {
    case "$1" in
        create|destroy)
            command=$1
            shift  # Remove the command from the arguments list
            set_param "$command" "$@"
            "${command}_server"
            ;;
        show)
            shift  # Remove 'show' from the arguments list
            set_param "show" "$@"
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


