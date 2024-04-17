
variable "gcp_project" {
  default = "platform-419411"
}

provider "google" {
  project = var.gcp_project
  region  = "europe-west2"
  zone    = "europe-west2-c"
}

module "gcp-net" {
  source = "../../terraform/raw_modules/gcp-network"
}

resource "google_service_account" "default" {
  account_id   = "platform-service-account"
  display_name = "Platform Service Account"
}

variable "owner" {
}

locals {
  project = "platform-gcp-example"
}

variable "public_key" {
  description = "Path to the public key to use"
  type        = string
  default     = "../../gdc-infra.pub"
}

module "gcp-servers" {
  count                 = 2
  source                = "../../terraform/raw_modules/gcp-vm-linux"
  basename              = local.project
  vm_name               = "server-${count.index}"
  owner                 = var.owner
  startup_script        = file("./startup.sh")
  tags                  = ["${local.project}-lb"]
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp-net.subnet_link
  ssh_publickey         = file(var.public_key)
  vm_size               = "m"
}

module "gcp-bastion" {
  source                = "../../terraform/raw_modules/gcp-vm-linux"
  basename              = local.project
  vm_name               = "bastion"
  owner                 = var.owner
  startup_script        = null
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp-net.subnet_link
  with_public_ip        = true
  ssh_publickey         = file(var.public_key)
}

module "gcp-lb" {
  source           = "../../terraform/raw_modules/gcp-region-lb"
  owner            = var.owner
  vpc_link         = module.gcp-net.vpc_link
  port_healtcheck  = 80
  port_listen      = 80
  target_instances = module.gcp-servers.*.link
  target_tags      = ["${local.project}-lb"]
}

output "lb-ip" {
  value = module.gcp-lb.lb_ip
}

output "bastion-ip" {
  value = module.gcp-bastion.public_ip
}

output "server-private-ips" {
  value = module.gcp-servers.*.private_ips
}
