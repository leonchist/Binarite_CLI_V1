
output "resource_ids" {
  value = {
    network : {
      vpc_id : module.aws_net.vpc_id,
      subnet_id : module.aws_net.subnet_id,
      security_group_id : module.aws_net.security_group_id
    },
    agents : module.eoc-agents.*.instance_id
  }
}

output "public_ips_eu" {
  value = module.eoc-agents.*.vm_public_ips
}
