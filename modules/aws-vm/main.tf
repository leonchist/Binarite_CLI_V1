data "aws_ami" "ubuntu2204" {
  most_recent = true

  filter {
    name   = "name"
    values = [ var.vm_configuration.source_image.name ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [ var.vm_configuration.source_image.publisher ] # Canonical
}

resource "aws_network_interface" "nic" {
  subnet_id   = var.subnet_id
  private_ips = [var.private_ip]
  security_groups = var.vpc_security_group_ids

  tags = var.env.tags
}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.ubuntu2204.id
  instance_type = var.vm_size

  key_name      = var.ssh_key_name

  user_data = templatefile(var.vm_configuration.startup_script, { AWS_ACCESS_KEY_ID=var.aws_secrets.key_id, AWS_SECRET_ACCESS_KEY=var.aws_secrets.access_key, PROVISION_URI=var.provision_uri })
  user_data_replace_on_change = true

  network_interface {
     network_interface_id = aws_network_interface.nic.id
     device_index = 0
  }

  tags = merge(var.env.tags, { Name = "${var.vm_name}"})
}