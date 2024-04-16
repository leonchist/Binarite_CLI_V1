terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/quark.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "gdc-terraform-infra"
    key    = "prod/network.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "elastic_ip" {
  backend = "s3"
  config = {
    bucket = "gdc-terraform-infra"
    key    = "prod/elastic_ip.tfstate"
    region = "eu-central-1"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/hosts.tpl", {
    quark_servers_eu_ips = flatten(module.quark-servers-eu.vm_public_ips),
    quark_servers_us_ips = flatten(module.quark-servers-us.vm_public_ips)

  })
  filename = "${path.module}/../../ansible/inventory/hosts.cfg"
}
