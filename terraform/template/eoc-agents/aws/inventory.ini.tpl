[eoc_agents]
%{ for ip in agents_ip ~}
${ip}
%{ endfor ~}

[eoc_agents:vars]
known_host=${known_host}
ansible_ssh_user=${agents_ssh_user}
ansible_ssh_private_key_file=${agents_ssh_key}
ansible_ssh_common_args='-o StrictHostKeyChecking=accept-new -o UserKnownHostsFile={{ known_host }}'
ansible_connection=ssh
ansible_shell_type=cmd
quark_ip=${quark_ip}
quark_port=${quark_port}