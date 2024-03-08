
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

output "bots_public_ip" {
    description = ""
    value = try(module.eoc-bots.vm_public_ips, module.eoc-bots.*.vm_public_ips)
}

output "bots_private_ip" {
    description = ""
    value = try(module.eoc-bots.vm_private_ips, module.eoc-bots.*.vm_private_ips)
}

output "private_key_pem" {
  description = "Private key data in PEM (RFC 1421) format"
  value       = try(trimspace(tls_private_key.rsa-windows-key.private_key_pem), "")
  sensitive   = true
}

output "ec2_password" {
    value = tostring(try(rsadecrypt(module.eoc-bots.password_data, tls_private_key.rsa-windows-key.private_key_pem), null))
    sensitive = true
}

output "grafana_public_ip" {
  value = module.grafana-prometheus.vm_public_ips
}