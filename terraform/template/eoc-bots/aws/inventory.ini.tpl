[eoc_bots]
%{ for ip in bots_ip ~}
${ip}
%{ endfor ~}

[eoc_bots:vars]
known_host=${known_host}
ansible_ssh_user=${bots_ssh_user}
ansible_ssh_private_key_file=${bots_ssh_key}
ansible_ssh_common_args='-o StrictHostKeyChecking=accept-new -o UserKnownHostsFile={{ known_host }}'
ansible_connection=ssh
ansible_shell_type=cmd
quark_ip=${quark_ip}
quark_port=${quark_port}