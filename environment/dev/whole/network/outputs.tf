output "security_group_id_us" {
  value = module.network-us.security_group_id
}

output "subnet_id_us" {
  value = module.network-us.subnet_id
}

output "vpc_id_us" {
  value = module.network-us.vpc_id
}

output "security_group_id_eu" {
  value = module.network-eu.security_group_id
}

output "subnet_id_eu" {
    value = module.network-eu.subnet_id
}

output "vpc_id_eu" {
  value = module.network-eu.vpc_id
}