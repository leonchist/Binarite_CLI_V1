output "security_group_id" {
  value = module.aws_net.security_group_id
}

output "subnet_id" {
  value = module.aws_net.subnet_id
}

output "vpc_id" {
  value = module.aws_net.vpc_id
}

output "quark_eip_allocation_id" {
  value = aws_eip.elastic_ip[0].allocation_id
}

output "quark_public_ip" {
  value = aws_eip.elastic_ip[0].public_ip
}

output "grafana_public_ip" {
  value = aws_eip.elastic_ip[1].public_ip
}

output "configuration_uuids" {
  value = random_uuid.uuid[*].result
}

output "quark_setup_uuid" {
  value = random_uuid.uuid[0].result
}

output "grafana_setup_uuid" {
  value = random_uuid.uuid[1].result
}