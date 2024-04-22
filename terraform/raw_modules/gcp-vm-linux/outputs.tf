output "link" {
  value = google_compute_instance.gcp-vm-linux.self_link
}

output "public_ip" {
  value = var.with_public_ip ? google_compute_address.static_ip[0].address : null
}

output "private_ips" {
  value = google_compute_instance.gcp-vm-linux.network_interface.*.network_ip
}
