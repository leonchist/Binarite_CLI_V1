
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

output "quark_nlb_dns_name" {
  value = module.region-lb.lb_dns_name
}

output "quark_nlb_zone_id" {
  value = module.region-lb.lb_zone_id
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
