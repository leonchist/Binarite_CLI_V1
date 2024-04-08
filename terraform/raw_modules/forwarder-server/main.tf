module "forwarder-server" {
  source                 = "../aws-vm-linux"
  count                  = var.forwarder_server_count
  vm_name                = format("tf-forwarder-server-%d", 1 + count.index)
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  aws_secrets            = var.aws_secrets
  ssh_key_name           = var.ssh_key_name
  private_ip             = format("10.0.1.%d", 15 + count.index)
  startup_script         = var.startup_script
  env                    = var.env
}


resource "aws_network_interface" "secondary_nic" {
  count = var.forwarder_server_count

  subnet_id       = var.backup_subnet_id
  security_groups = tolist(var.backup_vpc_security_group_ids)

  tags = merge(var.env.tags, {
    Name = lower("${var.env.tags.Project}-${var.env.tags.Role}-secondary-nic-${count.index}-${var.env.tags.Owner}")
  })
}

resource "aws_network_interface_attachment" "attach_secondary_nic" {
  count = var.forwarder_server_count

  instance_id          = module.forwarder-server[count.index].instance_id
  network_interface_id = aws_network_interface.secondary_nic[count.index].id
  device_index         = 1
}
