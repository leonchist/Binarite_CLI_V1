output "public_ips_eu" {
    value = module.eoc-bots-eu.*.vm_public_ips
}

output "public_ips_us" {
    value = module.eoc-bots-us.*.vm_public_ips
}