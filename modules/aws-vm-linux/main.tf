data "aws_ami" "linux_ami" {
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

module "aws-vm-linux" {
  source = "../../modules/aws-vm-base"
  vm_ami = data.aws_ami.linux_ami.id

  vm_name = var.vm_name
  vm_size = var.vm_size

  private_ip = var.private_ip

  vpc_security_group_ids = var.vpc_security_group_ids
  ssh_key_name = var.ssh_key_name
  subnet_id = var.subnet_id
  vm_user_data = templatefile(var.startup_script, { AWS_ACCESS_KEY_ID=var.aws_secrets.key_id, AWS_SECRET_ACCESS_KEY=var.aws_secrets.access_key, PROVISION_URI=var.provision_uri })
}