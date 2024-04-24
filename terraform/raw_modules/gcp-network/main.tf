resource "google_compute_network" "vpc" {
  name = "${var.basename}-vpc-${var.owner}"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.basename}-subnet-${var.owner}"
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = var.local_ip_cidr_range
}

resource "google_compute_router" "router" {
  name    = "${var.basename}-router-${var.owner}"
  network = google_compute_network.vpc.id
  region  = google_compute_subnetwork.subnet.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.basename}-nat-${var.owner}"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

locals {
  allow_ssh_fw_name = "${var.basename}-allow-ssh-fw-${var.owner}"
}

resource "google_compute_firewall" "allow_ssh" {
  name          = local.allow_ssh_fw_name
  network       = google_compute_network.vpc.self_link
  target_tags   = [local.allow_ssh_fw_name]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

locals {
  allow_ssh_local_fw_name = "${var.basename}-allow-ssh-local-fw-${var.owner}"
}

resource "google_compute_firewall" "allow_ssh_local" {
  name          = local.allow_ssh_local_fw_name
  network       = google_compute_network.vpc.self_link
  target_tags   = [local.allow_ssh_local_fw_name]
  source_ranges = [var.local_ip_cidr_range]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
