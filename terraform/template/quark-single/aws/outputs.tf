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

output "bastion_instance_id" {
  value = module.bastion.instance_id
}

output "quark_public_ip" {
  value = module.quark.vm_public_ips
}

output "quark_private_ip" {
  value = module.quark.vm_private_ips
}

output "grafana_public_ip" {
  value = module.grafana_prometheus.vm_public_ips
}

output "grafana_private_ip" {
  value = module.grafana_prometheus.vm_private_ips
}

output "bastion_public_ip" {
  value = module.bastion.vm_public_ips
}

output "elastic_ip_ids" {
  value = aws_eip.elastic_ip[*].id
}