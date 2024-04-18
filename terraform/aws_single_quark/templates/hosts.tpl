[proxy]
bastion-host ansible_host=${bastion_ip}

[quark]
${quark_ip}

[grafana]
${grafana_ip}

# [quark:vars]
# ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q metagravity@{{ hostvars["bastion-host"].ansible_host }}"'

# [grafana:vars]
# ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q metagravity@{{ hostvars["bastion-host"].ansible_host }}"'

[all:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q metagravity@{{ hostvars["bastion-host"].ansible_host }}"'
ansible_user=${ansible_user}
ansible_ssh_private_key_file=${private_key}