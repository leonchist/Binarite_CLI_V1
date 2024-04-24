output "vpc_link" {
  value = google_compute_network.vpc.self_link
}

output "subnet_link" {
  value = google_compute_subnetwork.subnet.self_link
}

output "resource_ids" {
  value = {
    vpc_id          = google_compute_network.vpc.id
    subnet_id       = google_compute_subnetwork.subnet.id
    router_id       = google_compute_router.router.id
    nat_id          = google_compute_router_nat.nat.id
    ssh_fw_id       = google_compute_firewall.allow_ssh.id
    ssh_fw_local_id = google_compute_firewall.allow_ssh_local.id
  }
}