
output "resource_ids" {
  value = {
    network : {
      vpc_id : module.aws_net.vpc_id,
      subnet_id : module.aws_net.subnet_id,
      security_group_id : module.aws_net.security_group_id
    },
    bots : module.eoc-bots.*.instance_id
  }
}

output "public_ips_eu" {
  value = module.eoc-bots.*.vm_public_ips
}
