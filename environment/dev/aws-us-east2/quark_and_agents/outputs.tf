output "quark_public_ip" {
    description = ""
    value = module.quark-server.*.vm_public_ips
}

output "quark_private_ips" {
    description = ""
    value = module.quark-server.*.vm_private_ips
}

output "agents_public_ip" {
    description = ""
    value = module.quark-agents.vm_public_ips
}

output "agents_private_ip" {
    description = ""
    value = module.quark-agents.vm_private_ips
}

output "grafana_public_ip" {
  value = module.grafana-prometheus.vm_public_ips
}