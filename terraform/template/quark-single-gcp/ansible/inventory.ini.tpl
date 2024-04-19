[bastion]
bastion-host ansible_host=${bastion_ip} remote_user=metagravity

[quark]
${quark_ip}

[grafana]
${grafana_ip}

[quark:vars]
ansible_ssh_common_args='{{ nodes_ssh_common_args }}'

[grafana:vars]
ansible_ssh_common_args='{{ nodes_ssh_common_args }}'

[all:vars]
ansible_user=${ansible_user}
ansible_ssh_private_key_file=${private_key}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
nodes_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -o StrictHostKeyChecking=no {{ ansible_user }}@{{ hostvars["bastion-host"].ansible_host }} -i {{ ansible_ssh_private_key_file }} -W %h:%p -q"'

