

module "aws-vm-windows" {
  source  = "../aws-vm-base"
  vm_ami  = var.ami_id
  vm_name = var.vm_name
  vm_size = var.vm_size

  vm_disk_size = 64

  vm_get_password = true

  private_ip = var.private_ip

  vpc_security_group_ids = var.vpc_security_group_ids
  ssh_key_name           = var.ssh_key_name
  subnet_id              = var.subnet_id
  vm_user_data           = var.vm_user_data

  env                    = var.env
}
