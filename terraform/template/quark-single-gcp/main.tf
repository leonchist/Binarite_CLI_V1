resource "google_service_account" "default" {
  account_id   = "platform-service-account"
  display_name = "Platform Service Account"
}

module "gcp-net" {
  source              = "../../../terraform/raw_modules/gcp-network"
  local_ip_cidr_range = var.subnet_local_ip_range
}

resource "google_compute_firewall" "allow_quark" {
  name          = "allow-quark"
  network       = module.gcp-net.vpc_link
  target_tags   = ["allow-quark"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["5670"]
  }
}


resource "google_compute_firewall" "allow_quark_metrics" {
  name          = "allow-quark-metrics"
  network       = module.gcp-net.vpc_link
  target_tags   = ["allow-quark-metrics"]
  source_ranges = [var.subnet_local_ip_range]

  allow {
    protocol = "tcp"
    ports    = ["9898"]
  }
}

module "quark" {
  source                = "../../../terraform/raw_modules/gcp-vm-linux"
  basename              = var.metadata.Project
  vm_name               = "quark"
  owner                 = var.metadata.Owner
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp-net.subnet_link
  ssh_publickey         = file(var.public_key)
  vm_size               = "l"
  with_public_ip        = true
  tags                  = ["allow-ssh-local", "allow-quark", "allow-quark-metrics"]
  ssh_username          = var.user
  metadata              = var.metadata
}


resource "google_compute_firewall" "allow_grafana" {
  name          = "allow-grafana"
  network       = module.gcp-net.vpc_link
  target_tags   = ["allow-grafana"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
}

module "grafana" {
  source                = "../../../terraform/raw_modules/gcp-vm-linux"
  basename              = var.metadata.Project
  vm_name               = "grafana"
  owner                 = var.metadata.Owner
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp-net.subnet_link
  ssh_publickey         = file(var.public_key)
  with_public_ip        = true
  tags                  = ["allow-ssh-local", "allow-grafana"]
  ssh_username          = var.user
  metadata              = var.metadata
}

module "bastion" {
  source                = "../../../terraform/raw_modules/gcp-vm-linux"
  basename              = var.metadata.Owner
  vm_name               = "bastion"
  owner                 = var.metadata.Owner
  startup_script        = null
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp-net.subnet_link
  with_public_ip        = true
  ssh_publickey         = file(var.public_key)
  tags                  = ["allow-ssh"]
  ssh_username          = var.user
  metadata              = var.metadata
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/ansible/inventory.ini.tpl", {
    bastion_ip   = module.bastion.public_ip
    quark_ip     = module.quark.private_ips[0]
    grafana_ip   = module.grafana.private_ips[0]
    ansible_user = var.user
    private_key  = abspath(var.private_key)
    known_host   = "${var.metadata.Project}-known-host"
  })
  filename = var.ansible_inventory_path
}
