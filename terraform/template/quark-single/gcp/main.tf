locals {
  metadata = jsondecode(file(var.environment))
}

resource "google_service_account" "default" {
  account_id   = "platform-service-account"
  display_name = "Platform Service Account"
}

data "google_compute_zones" "available" {
}

locals {
  gcp_zone = data.google_compute_zones.available.names[0]
}

module "gcp_net" {
  source              = "../../../../terraform/raw_modules/gcp-network"
  local_ip_cidr_range = var.subnet_local_ip_range
  basename            = local.metadata.Project
  owner               = local.metadata.Owner
}

locals {
  allow_quark_fw_tag         = "${local.metadata.Project}-quark-fw-${local.metadata.Owner}"
  allow_quark_metrics_fw_tag = "${local.metadata.Project}-quark-metrics-fw-${local.metadata.Owner}"
}

resource "google_compute_firewall" "allow_quark" {
  name          = local.allow_quark_fw_tag
  network       = module.gcp_net.vpc_link
  target_tags   = [local.allow_quark_fw_tag]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["5670"]
  }
}


resource "google_compute_firewall" "allow_quark_metrics" {
  name          = local.allow_quark_metrics_fw_tag
  network       = module.gcp_net.vpc_link
  target_tags   = [local.allow_quark_metrics_fw_tag]
  source_ranges = [var.subnet_local_ip_range]

  allow {
    protocol = "tcp"
    ports    = ["9898"]
  }
}

module "quark" {
  source                = "../../../../terraform/raw_modules/gcp-vm-linux"
  basename              = local.metadata.Project
  vm_name               = "quark"
  owner                 = local.metadata.Owner
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp_net.subnet_link
  ssh_publickey         = file(var.public_key)
  vm_size               = var.quark_vm_size
  with_public_ip        = true
  tags                  = [module.gcp_net.allow_ssh_local_fw_tag, local.allow_quark_fw_tag, local.allow_quark_metrics_fw_tag]
  ssh_username          = var.user
  metadata              = local.metadata
  zone                  = local.gcp_zone
}

locals {
  allow_grafana_fw_tag = "${local.metadata.Project}-grafana-fw-${local.metadata.Owner}"
}


resource "google_compute_firewall" "allow_grafana" {
  name          = local.allow_grafana_fw_tag
  network       = module.gcp_net.vpc_link
  target_tags   = [local.allow_grafana_fw_tag]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
}

module "grafana" {
  source                = "../../../../terraform/raw_modules/gcp-vm-linux"
  basename              = local.metadata.Project
  vm_name               = "grafana"
  owner                 = local.metadata.Owner
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp_net.subnet_link
  ssh_publickey         = file(var.public_key)
  with_public_ip        = true
  tags                  = [module.gcp_net.allow_ssh_local_fw_tag, local.allow_grafana_fw_tag]
  ssh_username          = var.user
  metadata              = local.metadata
  zone                  = local.gcp_zone
}

module "bastion" {
  source                = "../../../../terraform/raw_modules/gcp-vm-linux"
  basename              = local.metadata.Project
  vm_name               = "bastion"
  owner                 = local.metadata.Owner
  startup_script        = null
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp_net.subnet_link
  with_public_ip        = true
  ssh_publickey         = file(var.public_key)
  tags                  = [module.gcp_net.allow_ssh_fw_tag]
  ssh_username          = var.user
  metadata              = local.metadata
  zone                  = local.gcp_zone
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../common/ansible/inventory.ini.tpl", {
    bastion_ip   = module.bastion.public_ip
    quark_ip     = module.quark.private_ips[0]
    grafana_ip   = module.grafana.private_ips[0]
    ansible_user = var.user
    private_key  = abspath(var.private_key)
    known_host   = "${var.known_host_path}"
  })
  filename = var.ansible_inventory_path
}
