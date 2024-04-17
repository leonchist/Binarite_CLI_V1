# Found an alternative after writing the module...
# Mostly the same: https://registry.terraform.io/modules/GoogleCloudPlatform/lb/google/latest

locals {
  lb_name = "${var.basename}-loadbalancer-${var.owner}"
}

resource "google_compute_forwarding_rule" "default" {
  name                  = local.lb_name
  target                = google_compute_target_pool.default.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.port_listen
  ip_protocol           = "TCP"
}

resource "google_compute_firewall" "lb_firewall" {
  name    = "${var.basename}-lb-firewall-${var.owner}"
  network = var.vpc_link
  allow {
    protocol = "tcp"
    ports    = [var.port_listen]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.target_tags
}

resource "google_compute_target_pool" "default" {
  name             = "${var.basename}-target-pool-${var.owner}"
  session_affinity = "NONE"
  instances        = var.target_instances
  health_checks = [
    google_compute_http_health_check.default.self_link
  ]
}

resource "google_compute_http_health_check" "default" {
  name                = "${var.basename}-healthcheck-${var.owner}"
  port                = var.port_healtcheck
  check_interval_sec  = 30
  healthy_threshold   = 3
  unhealthy_threshold = 3
  timeout_sec         = 5
}

resource "google_compute_firewall" "health_check" {
  name    = "${var.basename}-hc-firewall-${var.owner}"
  network = var.vpc_link
  allow {
    protocol = "tcp"
    ports    = [var.port_healtcheck]
  }
  # ip range of health check probes : https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
  source_ranges = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]
  target_tags   = var.target_tags
}
