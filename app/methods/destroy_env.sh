#!/bin/bash
# Function to destroy a specific environment
destroy_env() {
    region="$1"  # Expect 'eu' or 'us' as argument
    echo "Destroying environment in the $region region"

    # Extract IPs for the specific region
    ips=$(awk -v region="quark_servers_$region" '$0 ~ region {flag=1; next} /^$/ {flag=0} flag' "${TERRAFORM_ENV_PATH}/../ansible/inventory/hosts.cfg")

    for ip in $ips; do
        module_path=$(get_module_path "quark")
        cd "$module_path" || exit
        terraform destroy -auto-approve -var "instance_ip=$ip"
    done
}
