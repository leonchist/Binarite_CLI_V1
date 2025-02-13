[bastion]
bastion-host ansible_host=${bastion_ip}

[quark_servers]
${quark_ip}

[grafana]
${grafana_ip}

[quark_servers:vars]
ansible_ssh_common_args='{{ nodes_ssh_common_args }}'

[grafana:vars]
ansible_ssh_common_args='{{ nodes_ssh_common_args }}'
docker_users=["{{ ansible_user }}"]

[all:vars]
known_host=${known_host}
ansible_user=${ansible_user}
ansible_ssh_private_key_file=${private_key}
ansible_ssh_common_args='-o StrictHostKeyChecking=accept-new -o UserKnownHostsFile={{ known_host }}'
nodes_ssh_common_args='-o StrictHostKeyChecking=accept-new -o UserKnownHostsFile={{ known_host }} -o ProxyCommand="ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile={{ known_host }} {{ ansible_user }}@{{ hostvars["bastion-host"].ansible_host }} -i {{ ansible_ssh_private_key_file }} -W %h:%p -q"'

