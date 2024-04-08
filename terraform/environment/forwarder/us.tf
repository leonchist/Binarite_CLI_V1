resource "aws_key_pair" "ssh_key_us" {
  public_key = file(var.public_key)
  provider   = aws.us_west_1
  tags = var.env.tags
}


module "forwarder-server-us" {
  source = "../../raw_modules/forwarder-server"
  count = var.forwarder_server_count

  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_us]
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id_us

  backup_vpc_security_group_ids = [data.terraform_remote_state.network.outputs.backup_security_group_id_us]
  backup_subnet_id       = data.terraform_remote_state.network.outputs.backup_subnet_id_us

  ssh_key_name = aws_key_pair.ssh_key_us.key_name
  aws_secrets = var.aws_secrets
  startup_script = "../../../scripts/startup_forwarder.sh"

  env = var.env

  providers = {
    aws = aws.us_west_1
  }
}


locals {
  us_flattened_instance_ids = flatten([for instance in module.forwarder-server-us : instance.instance_id])
}

locals {
  us_flattened_nic_ids = flatten([for instance in module.forwarder-server-us : instance.secondary_nic_ids])
}

resource "aws_eip_association" "eip_assoc_forwarder_us" {
  count = length(local.us_flattened_instance_ids)

  network_interface_id = local.us_flattened_nic_ids[count.index]
  allocation_id = data.terraform_remote_state.elastic_ip.outputs.forwarder_us[count.index].allocation_id

  provider      = aws.us_west_1
}
