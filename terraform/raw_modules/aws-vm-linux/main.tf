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


module "aws-vm-linux" {
  source = "../aws-vm-base"
  vm_ami = data.aws_ami.linux_ami.id

  vm_name = var.vm_name
  vm_size = var.vm_size

  private_ip             = var.private_ip
  vm_user_data           = var.startup_script
  vpc_security_group_ids = var.vpc_security_group_ids
  ssh_key_name           = var.ssh_key_name
  subnet_id              = var.subnet_id
  env                    = var.env
}
