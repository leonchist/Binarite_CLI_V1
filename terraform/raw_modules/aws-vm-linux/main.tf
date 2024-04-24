data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = var.ami_owner_alias

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = var.vm_user_data != null ? var.vm_user_data : <<EOF
  #cloud-config
  system_info:
    default_user:
      name: ${var.ssh_username}
  EOF
}


module "aws-vm-linux" {
  source = "../aws-vm-base"
  vm_ami = data.aws_ami.linux_ami.id

  vm_name = var.vm_name
  vm_size = var.vm_size

  private_ip             = var.private_ip
  vm_user_data           = local.user_data
  vpc_security_group_ids = var.vpc_security_group_ids
  ssh_key_name           = var.ssh_key_name
  subnet_id              = var.subnet_id
  env                    = var.env
}
