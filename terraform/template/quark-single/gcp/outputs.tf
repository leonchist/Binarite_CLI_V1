output "bastion-public_ip" {
  value = module.bastion.public_ip
}

output "quark-public_ip" {
  value = module.quark.public_ip
}

output "quark-private_ips" {
  value = module.quark.private_ips
}

output "grafana-public_ip" {
  value = module.grafana.public_ip
}

output "grafana-private_ips" {
  value = module.grafana.private_ips
}