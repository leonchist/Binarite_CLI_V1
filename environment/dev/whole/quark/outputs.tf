output "eu_quark_servers_ids" {
  value = module.quark-servers-eu.instance_id
}

output "eu_quark_servers_private_ips" {
  value = module.quark-servers-eu.vm_private_ips
}

output "eu_quark_servers_public_ips" {
  value = module.quark-servers-eu.vm_public_ips
}

output "us_quark_servers_ids" {
  value = module.quark-servers-us.instance_id
}

output "us_quark_servers_private_ips" {
  value = module.quark-servers-us.vm_private_ips
}

output "us_quark_servers_public_ips" {
  value = module.quark-servers-us.vm_public_ips
}
