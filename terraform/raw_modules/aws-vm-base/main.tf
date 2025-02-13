
resource "aws_network_interface" "nic" {
  subnet_id       = var.subnet_id
  private_ips     = [var.private_ip]
  security_groups = var.vpc_security_group_ids
  tags            = var.env.tags
}

resource "aws_instance" "vm" {
  ami           = var.vm_ami
  instance_type = lookup(var.available_vm_size, var.vm_size, var.vm_size)

  key_name = var.ssh_key_name

  user_data_replace_on_change = true

  get_password_data = var.vm_get_password
  user_data = var.vm_user_data

  root_block_device {
    volume_size = var.vm_disk_size
  }

  network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
  }
  tags = var.env.tags
}

