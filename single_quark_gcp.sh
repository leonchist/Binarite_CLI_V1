#!/bin/bash

if [ "$1" ]; then
uuid=$1
else
uuid=$(uuid)
fi

app_dir="/home/tjo/GDC_infra"
root_dir="$app_dir/temp/$uuid"

owner="thibault"
project="cli-gcp"

export TF_IN_AUTOMATION=1
export TF_DATA_DIR=$root_dir/.terraform

export TF_VAR_public_key="$app_dir/gdc-infra.pub"
export TF_VAR_private_key="$app_dir/gdc-infra"
export TF_VAR_subnet_local_ip_range="10.0.10.0/24"

# Generate JSON using jq
json=$(jq -n \
  --arg owner "$owner" \
  --arg project "$project" \
  --arg uuid "$uuid" \
  '{
    Owner: $owner,
    Project: $project,
    Uuid: $uuid,
    Env: "Dev",
    Role: "Cluster",
  }')

export TF_VAR_metadata=$json
echo $TF_VAR_metadata

export TF_VAR_ansible_inventory_path="$root_dir/ansible/inventory/hosts.ini"
export TF_VAR_known_host_path=$root_dir/known_hosts

tf_state=$root_dir/state/terraform.tfstate
tf_conf="$app_dir/terraform/template/quark-single/gcp"

if [ "$1" ]; then
    terraform -chdir="$tf_conf" destroy -input=false -auto-approve
    exit 0
fi

terraform -chdir="$tf_conf" init -input=false -backend-config="path=$tf_state"
terraform -chdir="$tf_conf" plan -input=false
terraform -chdir="$tf_conf" apply -input=false -auto-approve

export ANSIBLE_CONFIG=$app_dir/ansible.cfg

# touch $TF_VAR_known_host_path

# echo sleeping 10s...
# sleep 10

env
echo "ansible all -vvvvv -m ping -i $TF_VAR_ansible_inventory_path"
# exec strace -o strace.log ansible all -vvvvv -m ping -i $TF_VAR_ansible_inventory_path

echo "new cluster uuid : $uuid"

ansible all -vvvvv -m ping -i $TF_VAR_ansible_inventory_path

while [ $? -ne 0 ]; do
  echo "waiting for nodes to come online"
  sleep 10
  ansible all -vvvvv -m ping -i $TF_VAR_ansible_inventory_path
done

ansible-playbook -i $TF_VAR_ansible_inventory_path ./ansible/playbooks/single_quark.yaml

echo "new cluster uuid : $uuid"