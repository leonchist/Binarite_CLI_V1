
resource "aws_network_interface" "nic" {
  subnet_id   = var.subnet_id
  private_ips = [var.private_ip]
  security_groups = var.vpc_security_group_ids

  tags = var.env.tags
}

resource "aws_instance" "vm" {
  ami           = var.vm_ami
  instance_type = var.vm_size

  key_name      = var.ssh_key_name

  user_data = var.vm_user_data
  user_data_replace_on_change = true

  network_interface {
     network_interface_id = aws_network_interface.nic.id
     device_index = 0
  }

  tags = merge(var.env.tags, { Name = "${var.vm_name}"})
}


resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.vm.id
  allocation_id = var.eip_allocation_id
}
