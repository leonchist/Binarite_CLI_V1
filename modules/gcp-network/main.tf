resource "google_compute_network" "vpc" {
  name = "${var.basename}-vpc-${var.owner}"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.basename}-subnet-${var.owner}"
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = "10.0.1.0/24"
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

resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  network       = google_compute_network.vpc.self_link
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
