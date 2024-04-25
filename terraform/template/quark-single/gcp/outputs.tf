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

output "public_ips" {
  value = {
    quark = module.quark.public_ip
    grafana = module.grafana.public_ip
    bastion = module.bastion.public_ip
  }
}

output "private_ips" {
    value = {
    quark : module.quark.private_ips,
    grafana : module.grafana.private_ips,
    bastion : module.bastion.private_ips,
  }
}