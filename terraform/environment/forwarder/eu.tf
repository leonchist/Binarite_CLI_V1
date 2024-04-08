resource "aws_key_pair" "ssh_key_eu" {
  public_key = file(var.public_key)
  provider   = aws.eu_central_1
  tags = var.env.tags
}


module "forwarder-server-eu" {
  source = "../../raw_modules/forwarder-server"
  count = var.forwarder_server_count

  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_eu]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_id_eu

  backup_vpc_security_group_ids = [data.terraform_remote_state.network.outputs.backup_security_group_id_eu]
  backup_subnet_id       = data.terraform_remote_state.network.outputs.backup_subnet_id_eu

  ssh_key_name = aws_key_pair.ssh_key_eu.key_name
  aws_secrets = var.aws_secrets
  startup_script = "../../../scripts/startup_forwarder.sh"

  env = var.env

  providers = {
    aws = aws.eu_central_1
  }
}

locals {
  eu_flattened_instance_ids = flatten([for instance in module.forwarder-server-eu : instance.instance_id])
}

locals {
  eu_flattened_nic_ids = flatten([for instance in module.forwarder-server-eu : instance.secondary_nic_ids])
}

resource "aws_eip_association" "eip_assoc_forwarder_eu" {
  count = length(local.eu_flattened_instance_ids)

  network_interface_id = local.eu_flattened_nic_ids[count.index]
  allocation_id = data.terraform_remote_state.elastic_ip.outputs.forwarder_eu[count.index].allocation_id

  provider      = aws.eu_central_1
}
