
output "quark_public_ip1" {
    description = ""
    value = module.quark-server1.vm_public_ips
}

output "quark_private_ips1" {
    description = ""
    value = module.quark-server1.vm_private_ips
}

output "quark_public_ip2" {
    description = ""
    value = module.quark-server2.vm_public_ips
}

output "quark_private_ips2" {
    description = ""
    value = module.quark-server2.vm_private_ips
}

output "quark_public_assigned_ip1" {
  value = var.eip_us_west1_quark1
}

output "quark_public_assigned_ip2" {
  value = var.eip_us_west1_quark2
}

#output "agents_public_ip" {
#    description = ""
#    value = module.quark-agents.vm_public_ips
#}
#
#output "agents_private_ip" {
#    description = ""
#    value = module.quark-agents.vm_private_ips
#}
#
#output "bots_public_ip" {
#    description = ""
#    value = module.eoc-bots.vm_public_ips
#}
#
#output "bots_private_ip" {
#    description = ""
#    value = module.eoc-bots.vm_private_ips
#}

output "private_key_pem" {
  description = "Private key data in PEM (RFC 1421) format"
  value       = try(trimspace(tls_private_key.rsa-windows-key.private_key_pem), "")
  sensitive   = true
}
