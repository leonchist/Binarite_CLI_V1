resource "aws_key_pair" "ssh_key" {
  public_key = file(var.public_key)
  provider   = aws
  tags       = var.env.tags
}

module "quark" {
  source = "../raw_modules/aws-vm-linux"

  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  vm_name                = "quark"
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  aws_secrets            = var.aws_secrets
  startup_script         = "../../scripts/startup.sh"
  eip_allocation_id      = aws_eip.elastic_ip[0].allocation_id
  private_ip             = var.quark_private_ip
  vm_size = var.vm_size

  env = merge(var.env, {
    tags = merge(var.env.tags, { Name = "quark_server-${random_uuid.uuid.result}" })
  })

  providers = {
    aws = aws
  }
}

module "grafana-prometheus" {
  source                 = "../raw_modules/aws-vm-linux"
  vm_name                = "grafana-prometheus"
  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  aws_secrets            = var.aws_secrets
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  provision_uri          = "s3://quark-deployment/prometheus-grafana.tar.gz"
  private_ip             = var.grafana_private_ip
  startup_script         = "../../scripts/startup.sh"

  env = merge(var.env, {
    tags = merge(var.env.tags, { Name = "grafana_server-${random_uuid.uuid.result}" })
  })

  providers = {
    aws = aws
  }
}

module "bastion" {
  source                 = "../raw_modules/aws-vm-linux"
  vm_name                = "bastion"
  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  aws_secrets            = var.aws_secrets
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  private_ip             = var.bastion_private_ip
  startup_script         = "../../scripts/startup.sh"

  env = merge(var.env, {
    tags = merge(var.env.tags, { Name = "bastion_server-${random_uuid.uuid.result}" })
  })

  providers = {
    aws = aws
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/hosts.tpl", {
    quark_ip     = aws_eip.elastic_ip[0].public_ip,
    grafana_ip   = aws_eip.elastic_ip[1].public_ip,
    bastion_ip   = aws_eip.elastic_ip[2].public_ip,
    ansible_user = "metagravity",
    private_key  = abspath(var.private_key)
  })
  filename = "${path.module}/../../ansible/inventory/${random_uuid.uuid.result}/hosts.cfg"
}
