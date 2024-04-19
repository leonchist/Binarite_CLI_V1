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

output "quark_deployment_id" {
  value = random_uuid.uuid.result
}