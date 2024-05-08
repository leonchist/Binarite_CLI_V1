#!/bin/bash
# server.sh - Script to handle server management commands with variable parameters.

# Get paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Source external methods
source "$SCRIPT_DIR/region.sh"
source "$SCRIPT_DIR/label.sh"

# Default values
instance_size="l"
instance_count=1
cloud_provider="gcp"
cloud_region="europe-west1"
git_repository=""
git_branch=""
uuid=$(uuidgen)
owner=$OWNER
project=""
label=""
public_ssh_key=""
private_ssh_key_path=""

# Usage function for displaying help
usage() {
    echo "Usage:"
    echo "  mg server create -project project_name [-label local_label] [-size instance_size] [-count instance_count] [-cloud cloud_provider] [-repo git_repository] [-branch git_branch]  [-region region]"
    echo "  mg server destroy -id UUID/label"
    echo "  mg server show -id UUID/label"
    echo "  mg server list"
    echo "  mg server help"
    exit 1
}

# Set parameters based on the command line arguments
set_param() {
    local project_set=false
    local require_project=true
    local require_label=true
    local command="$1"
    shift # remove the command from the parameters to process options


    if [[ "$command" == "show"  || "$command" == "destroy" ]]; then
        require_project=false
        require_label=false
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
            -label)
                label="$2"; shift 2;;
            -private-key)
                private_ssh_key_path="$2"; shift 2;;
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

    if [[ -n "$private_ssh_key_path" && ! -f "$private_ssh_key_path" ]]; then
        echo "Error: private key \"$private_ssh_key_path\" not found."
        exit 1
    fi

    if [[ -z "$label" && $require_label == true ]]; then
        label=$(generate_random_label)
    fi

    if [[ -n "$private_ssh_key_path" && -f "$private_ssh_key_path" ]]; then
        public_ssh_key=$(ssh-keygen -f $private_ssh_key_path -y)
        retVal=$?
        if [[ $retVal -ne 0 ]]; then
            echo "Error: reading private key \"$private_ssh_key_path\"."
            exit 1
        fi
    fi
}

set_credentials() {
    export GOOGLE_APPLICATION_CREDENTIALS="$ROOT_DIR/.credentials/google.json"
    export $(cat "$ROOT_DIR/.credentials/aws" | xargs)
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
    export TF_VAR_deployment_folder=$work_dir
    export TF_VAR_ansible_inventory_path="$work_dir/ansible/inventory/hosts.ini"
    export TF_VAR_known_host_path="$work_dir/known_hosts"
    export ANSIBLE_CONFIG="$ROOT_DIR/ansible.cfg"
    export TF_DATA_DIR="$work_dir/.terraform"
    export TF_IN_AUTOMATION=1

    tf_state=$work_dir/state/terraform.tfstate
    tf_conf="$ROOT_DIR/terraform/template/quark-single/$cloud_provider"
    creation_date=$(date '+%Y-%m-%d %H:%M:%S')
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
        echo "TF_VAR_deployment_folder=$work_dir"
        echo "TF_VAR_ansible_inventory_path=$TF_VAR_ansible_inventory_path"
        echo "TF_VAR_known_host_path=$TF_VAR_known_host_path"
        echo "ANSIBLE_CONFIG=$ANSIBLE_CONFIG"
        echo "TF_DATA_DIR=$TF_DATA_DIR"
        echo "TF_IN_AUTOMATION=$TF_IN_AUTOMATION"
        echo "tf_state=$tf_state"
        echo "tf_conf=$tf_conf"
        echo "JSON_Creation_File=$json_file"
        echo "Label=$label"
        echo "CreationDate=\"$creation_date\""
    } > "$meta_file"

    if [[ -n $public_ssh_key ]]; then
        export TF_VAR_public_key="$public_ssh_key"
        export TF_VAR_private_key_path="$(realpath $private_ssh_key_path)"
        {
            echo TF_VAR_public_key=\"$public_ssh_key\"
            echo TF_VAR_private_key_path=\"$(realpath $private_ssh_key_path)\"
        } >> "$meta_file"
    fi

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
      echo -e "\033[1;32mStarting server setup with the following parameters:\033[0m"
      echo "------------------------------------------------------------"

      # Project Details
      echo -e "\033[1;34mProject Details:\033[0m"
      echo -e "  \033[1;33mProject name:\033[0m $project"
      if [[ -n "$git_repository" ]]; then
          echo -e "  \033[1;33mRepository:\033[0m $git_repository"
          echo -e "  \033[1;33mBranch:\033[0m $git_branch"
      fi

      # Server Configuration
      echo -e "\033[1;34mServer Configuration:\033[0m"
      echo -e "  \033[1;33mInstance size:\033[0m $instance_size"
      echo -e "  \033[1;33mInstance count:\033[0m $instance_count"
      echo -e "  \033[1;33mCloud provider:\033[0m $cloud_provider"
      echo -e "  \033[1;33mCloud region:\033[0m $cloud_region"

      # Environment Details
      echo -e "\033[1;34mEnvironment:\033[0m"
      echo -e "  \033[1;33mID:\033[0m $uuid"
      echo -e "  \033[1;33mLabel:\033[0m $label"
      echo "------------------------------------------------------------"

    apply_server_module
}

resolve_env() {
    if [[ -d "$HOME/.mg/$1" ]]; then
        # Directly use the directory if it exists, assuming $1 is a UUID
        uuid=$1
    else
        # If it's not a UUID, resolve it as a label
        local metafile=$(find "$HOME/.mg" -type f -name metadata -exec grep -l "Label=$1" {} \;)
        if [[ -z "$metafile" ]]; then
            echo "Error: No environment found with the provided identifier."
            exit 1
        fi
        uuid=$(basename $(dirname "$metafile"))
    fi

    # Once the UUID is determined, source the metadata file
    local metadata_path="$HOME/.mg/$uuid/metadata"
    if [[ -f "$metadata_path" ]]; then
        set -a  # Automatically export all variables
        source "$metadata_path"
        set +a  # Stop automatic export
    else
        echo "Error: Metadata file not found for UUID: $uuid"
        exit 1
    fi
}

show_server() {
    local id=$uuid
    resolve_env "$id"

    local base_dir="$HOME/.mg/$uuid"
    local state_file_path="$base_dir/state/terraform.tfstate"

    if [[ -f "$state_file_path" ]]; then
        echo -n "Environment ID resolved to: $uuid"
        if [[ "$id" != "$uuid" ]]; then
            echo " / $id"
        else
            echo
        fi

        echo "State file path: $state_file_path"
        local ips=$(jq -r '.outputs.public_ips.value' "$state_file_path")
        echo "Public IPs: $ips"
    else
        echo "Error: State file does not exist for this UUID at the expected path: $state_file_path"
    fi
}



destroy_server() {
    local id=$uuid
    resolve_env "$id"

    local base_dir="$HOME/.mg/$uuid"
    local meta_file="$base_dir/metadata"


    local tf_conf="$ROOT_DIR/terraform/template/quark-single/$TF_VAR_cloud_provider"
    local state_file="$base_dir/state/terraform.tfstate"
    local json_file="$base_dir/creation.json"

    # Check if the configuration directory exists before proceeding
    if [[ -d "$tf_conf" ]]; then
        # Initialize Terraform with the specific state file and reconfigure
        terraform -chdir="$tf_conf" init -input=false -reconfigure -backend-config="path=$state_file"

        # Run destroy with the required variables and capture the exit code
        if terraform -chdir="$tf_conf" destroy -input=false -auto-approve \
            -var "cloud_region=$TF_VAR_cloud_region" \
            -var "ansible_inventory_path=$TF_VAR_ansible_inventory_path" \
            -var "known_host_path=$TF_VAR_known_host_path" \
            -var "environment=$json_file"
        then
            echo "Terraform destroy was successful. Removing directory: $base_dir"
            rm -rf "$base_dir"
        else
            echo "Error: Terraform destroy failed. Directory not removed: $base_dir"
        fi
    else
        echo "Error: Terraform configuration directory does not exist: $tf_conf"
        return
    fi
}

list_environments() {
    echo -e "\033[1;32mListing all environments:\033[0m"
    local count=1
    find "$HOME/.mg" -type f -name metadata | while read -r metadata_file; do
        uuid=$(basename "$(dirname "$metadata_file")")
        label=$(grep 'Label=' "$metadata_file" | cut -d '=' -f 2)
        creation_date=$(grep 'CreationDate=' "$metadata_file" | cut -d '=' -f 2)

        # Print UUID and Label on the same line
        echo -e "\033[1;33m$count. UUID: \033[1;34m$uuid / \033[1;36m$label\033[0m"
        echo -e "\033[1;33m   Created on: \033[1;34m$creation_date\033[0m"
        ((count++))
    done
}


server() {
    case "$1" in
        create|destroy|show)
            command=$1
            shift  # Remove the command from the arguments list
            set_param "$command" "$@"
            set_credentials
            "${command}_server"
            ;;
        list)
            list_environments
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


