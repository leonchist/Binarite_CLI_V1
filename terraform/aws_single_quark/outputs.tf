output "security_group_id" {
  value = module.aws_net.security_group_id
}

output "subnet_id" {
  value = module.aws_net.subnet_id
}

output "vpc_id" {
  value = module.aws_net.vpc_id
}

output "quark_instance_id" {
  value = module.quark.instance_id
}

output "grafana_instance_id" {
  value = module.grafana_prometheus.instance_id
}

output "bastion" {
  value = module.bastion.instance_id
}

output "quark_public_ip" {
  value = aws_eip.elastic_ip[0].public_ip
}

output "grafana_public_ip" {
  value = aws_eip.elastic_ip[1].public_ip
}

output "bastion_public_ip" {
  value = aws_eip.elastic_ip[2].public_ip
}

output "elastic_ip_ids" {
  value = aws_eip.elastic_ip[*].id
}