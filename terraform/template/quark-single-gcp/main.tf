resource "google_service_account" "default" {
  account_id   = "platform-service-account"
  display_name = "Platform Service Account"
}

module "gcp-net" {
  source = "../../../terraform/raw_modules/gcp-network"
}

module "quark" {
  source                = "../../../terraform/raw_modules/gcp-vm-linux"
  basename              = var.project
  vm_name               = "quark"
  owner                 = var.owner
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp-net.subnet_link
  ssh_publickey         = file(var.public_key)
  vm_size               = "l"
  with_public_ip        = true
  tags                  = ["allow-ssh-local"]
  ssh_username          = var.user
}

module "grafana" {
  source                = "../../../terraform/raw_modules/gcp-vm-linux"
  basename              = var.project
  vm_name               = "grafana"
  owner                 = var.owner
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp-net.subnet_link
  ssh_publickey         = file(var.public_key)
  with_public_ip        = true
  tags                  = ["allow-ssh-local"]
  ssh_username          = var.user
}

module "bastion" {
  source                = "../../../terraform/raw_modules/gcp-vm-linux"
  basename              = var.project
  vm_name               = "bastion"
  owner                 = var.owner
  startup_script        = null
  service_account_email = google_service_account.default.email
  subnet_link           = module.gcp-net.subnet_link
  with_public_ip        = true
  ssh_publickey         = file(var.public_key)
  tags                  = ["allow-ssh"]
  ssh_username          = var.user
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/ansible/inventory.ini.tpl", {
    bastion_ip   = module.bastion.public_ip
    quark_ip     = module.quark.private_ips[0]
    grafana_ip   = module.grafana.private_ips[0]
    ansible_user = var.user
    private_key  = abspath(var.private_key)
    known_host   = "${var.project}-known-host"
  })
  filename = "${path.module}/../../../env/${var.project}/ansible/inventory/hosts.ini"
}
