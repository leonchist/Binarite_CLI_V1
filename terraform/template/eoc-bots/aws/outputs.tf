output "public_ips_eu" {
  value = module.eoc-bots.*.vm_public_ips
}
