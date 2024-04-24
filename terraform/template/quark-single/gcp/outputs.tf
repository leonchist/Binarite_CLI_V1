output "resource_ids" {
  value = {
    network = module.gcp_net.resource_ids
    quark = merge(module.quark.resource_ids, {
      quark_fw         = google_compute_firewall.allow_quark.id
      quark_metrics_fw = google_compute_firewall.allow_quark_metrics.id
    })
    grafana = merge(module.grafana.resource_ids, {
      grafana_fw = google_compute_firewall.allow_grafana.id
    })
    bastion = module.bastion.resource_ids
  }
}

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