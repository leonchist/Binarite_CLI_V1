resource "aws_key_pair" "ssh_key" {
  public_key = file(var.public_key)
  provider   = aws
  tags       = var.env.tags
}

module "quark" {
  source = "../../../raw_modules/aws-vm-linux"

  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  vm_name                = "quark"
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  private_ip             = var.quark_private_ip
  vm_size                = "l"
  env = merge(var.env, {
    tags = merge(var.env.tags, { Name = "quark_server-${var.quark_deployment_id}" })
  })

  providers = {
    aws = aws
  }
}

module "grafana_prometheus" {
  source                 = "../../../raw_modules/aws-vm-linux"
  vm_name                = "grafana-prometheus"
  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  private_ip             = var.grafana_private_ip

  env = merge(var.env, {
    tags = merge(var.env.tags, { Name = "grafana_server-${var.quark_deployment_id}" })
  })

  providers = {
    aws = aws
  }
}

module "bastion" {
  source                 = "../../../raw_modules/aws-vm-linux"
  vm_name                = "bastion"
  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  private_ip             = var.bastion_private_ip

  env = merge(var.env, {
    tags = merge(var.env.tags, { Name = "bastion_server-${var.quark_deployment_id}" })
  })

  providers = {
    aws = aws
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../common/ansible/inventory.ini.tpl", {
    quark_ip     = module.quark.vm_private_ips[0]
    grafana_ip   = module.grafana_prometheus.vm_private_ips[0],
    bastion_ip   = module.bastion.vm_public_ips[0],
    ansible_user = var.user,
    private_key  = abspath(var.private_key)
    known_host   = var.known_host_path
  })
  filename = var.ansible_inventory_path
}
