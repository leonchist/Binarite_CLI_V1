# hosts.tpl
[quark_servers_eu]
%{ for ip in quark_servers_eu_ips ~}
${ip}
%{ endfor ~}

[quark_servers_us]
%{ for ip in quark_servers_us_ips ~}
${ip}
%{ endfor ~}
