data "aws_ami" "windows_ami" {
  most_recent = true
  owners = var.ami_owner_alias

  filter {
    name   = "name"
    values = [ var.ami_name ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "aws-vm-windows" {
  source = "../../modules/aws-vm-base"
  vm_ami = data.aws_ami.windows_ami.id
  vm_name = var.vm_name
  vm_size = var.vm_size

  vm_disk_size = 60

  vm_get_password = true

  private_ip = var.private_ip

  vpc_security_group_ids = var.vpc_security_group_ids
  ssh_key_name = var.ssh_key_name
  subnet_id = var.subnet_id
  vm_user_data = var.vm_user_data
}